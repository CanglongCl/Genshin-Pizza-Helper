//
//  Account.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/9.
//  Account所需的所有信息

import Foundation
import HBMihoyoAPI

// MARK: - Account

struct Account: Equatable, Hashable {
    // MARK: Lifecycle

    init(config: AccountConfiguration) {
        self.config = config
    }

    // MARK: Internal

    var config: AccountConfiguration

    // 树脂等信息
    var result: FetchResult?
    var background: WidgetBackground = .randomNamecardBackground
    var basicInfo: BasicInfos?
    var fetchComplete: Bool = false

    #if !os(watchOS)
    var playerDetailResult: Result<
        PlayerDetail,
        PlayerDetail.PlayerDetailError
    >?
    var fetchPlayerDetailComplete: Bool = false

    // 深渊
    var spiralAbyssDetail: AccountSpiralAbyssDetail?
    // 账簿，旅行札记
    var ledgeDataResult: LedgerDataFetchResult?
    #endif

    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.config == rhs.config
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(config)
    }
}

extension AccountConfiguration {
    func fetchResult(_ completion: @escaping (FetchResult) -> ()) {
        guard (uid != nil) || (cookie != nil)
        else { completion(.failure(.noFetchInfo)); return }

        MihoyoAPI.fetchInfos(
            region: server.region,
            serverID: server.id,
            uid: uid!,
            cookie: cookie!
        ) { result in
            completion(result)
            #if !os(watchOS)
            switch result {
            case let .success(data):
                UserNotificationCenter.shared.createAllNotification(
                    for: self.name!,
                    with: data,
                    uid: self.uid!
                )
                #if canImport(ActivityKit)
                if #available(iOS 16.1, *) {
                    ResinRecoveryActivityController.shared
                        .updateResinRecoveryTimerActivity(
                            for: self,
                            using: result
                        )
                }
                #endif
            case .failure:
                break
            }
            #endif
        }
    }

    func fetchSimplifiedResult(
        _ completion: @escaping (SimplifiedUserDataResult)
            -> ()
    ) {
        guard let cookie = cookie
        else { completion(.failure(.noFetchInfo)); return }
        guard cookie.contains("stoken")
        else { completion(.failure(.noStoken)); return }
        MihoyoAPI.fetchSimplifiedInfos(cookie: cookie) { result in
            completion(result)
            #if !os(watchOS)
            switch result {
            case let .success(data):
                UserNotificationCenter.shared.createAllNotification(
                    for: self.name!,
                    with: data,
                    uid: self.uid!
                )
            case .failure:
                break
            }
            #endif
        }
    }

    func fetchBasicInfo(_ completion: @escaping (BasicInfos) -> ()) {
        MihoyoAPI.fetchBasicInfos(
            region: server.region,
            serverID: server.id,
            uid: uid ?? "",
            cookie: cookie ?? ""
        ) { result in
            switch result {
            case let .success(data):
                completion(data)
            case .failure:
                print("fetching basic info error")
            }
        }
    }

    #if !os(watchOS)
    func fetchPlayerDetail(
        dateWhenNextRefreshable: Date?,
        _ completion: @escaping (Result<
            PlayerDetailFetchModel,
            PlayerDetail.PlayerDetailError
        >) -> ()
    ) {
        guard let uid = uid else { return }
        API.OpenAPIs.fetchPlayerDetail(
            uid,
            dateWhenNextRefreshable: dateWhenNextRefreshable
        ) { result in
            completion(result)
        }
    }

    func fetchAbyssInfo(
        round: AbyssRound,
        _ completion: @escaping (SpiralAbyssDetail) -> ()
    ) {
        // thisAbyssData
        MihoyoAPI.fetchSpiralAbyssInfos(
            region: server.region,
            serverID: server.id,
            uid: uid!,
            cookie: cookie!,
            scheduleType: round.rawValue
        ) { result in
            switch result {
            case let .success(resultData):
                completion(resultData)
            case .failure:
                print("Fail")
            }
        }
    }

    func fetchAbyssInfo(
        _ completion: @escaping (AccountSpiralAbyssDetail)
            -> ()
    ) {
        var this: SpiralAbyssDetail?
        var last: SpiralAbyssDetail?
        let group = DispatchGroup()
        group.enter()
        fetchAbyssInfo(round: .this) { data in
            this = data
            group.leave()
        }
        group.enter()
        fetchAbyssInfo(round: .last) { data in
            last = data
            group.leave()
        }
        group.notify(queue: .main) {
            guard let this = this, let last = last else { return }
            completion(AccountSpiralAbyssDetail(this: this, last: last))
        }
    }

    func fetchLedgerData(
        _ completion: @escaping (LedgerDataFetchResult)
            -> ()
    ) {
        MihoyoAPI.fetchLedgerInfos(
            month: 0,
            uid: uid!,
            serverID: server.id,
            region: server.region,
            cookie: cookie!
        ) { result in
            completion(result)
        }
    }

    enum AbyssRound: String {
        case this = "1", last = "2"
    }
    #endif
}

extension Account {
    #if !os(watchOS)
    func uploadHoldingData() {
        print("uploadHoldingData START")
        guard UserDefaults.standard.bool(forKey: "allowAbyssDataCollection")
        else { print("not allowed"); return }
        let userDefault = UserDefaults.standard
        var hasUploadedAvatarHoldingDataMD5: [String] = userDefault
            .array(forKey: "hasUploadedAvatarHoldingDataMD5") as? [String] ??
            []
        if let avatarHoldingData = AvatarHoldingData(
            account: self,
            which: .this
        ) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try! encoder.encode(avatarHoldingData)
            let md5 = String(data: data, encoding: .utf8)!.md5
            guard !hasUploadedAvatarHoldingDataMD5.contains(md5) else {
                print(
                    "uploadHoldingData ERROR: This holding data has uploaded. "
                ); return
            }
            guard !UPLOAD_HOLDING_DATA_LOCKED
            else { print("uploadHoldingDataLocked is locked"); return }
            lock()
            API.PSAServer.uploadUserData(
                path: "/user_holding/upload",
                data: data
            ) { result in
                switch result {
                case .success:
                    print("uploadHoldingData SUCCEED")
                    saveMD5()
                    print(md5)
                    print(hasUploadedAvatarHoldingDataMD5)
                case let .failure(error):
                    switch error {
                    case let .uploadError(message):
                        if message == "uid existed" || message ==
                            "Insert Failed" {
                            saveMD5()
                        }
                    default:
                        break
                    }
                }
                unlock()
            }
            func saveMD5() {
                hasUploadedAvatarHoldingDataMD5.append(md5)
                userDefault.set(
                    hasUploadedAvatarHoldingDataMD5,
                    forKey: "hasUploadedAvatarHoldingDataMD5"
                )
            }

        } else {
            print(
                "uploadAbyssData ERROR: generate data fail. Maybe because not full star."
            )
        }
        func unlock() {
            UPLOAD_HOLDING_DATA_LOCKED = false
        }
        func lock() {
            UPLOAD_HOLDING_DATA_LOCKED = true
        }
    }

    func uploadAbyssData() {
        print("uploadAbyssData START")
        guard UserDefaults.standard.bool(forKey: "allowAbyssDataCollection")
        else { print("not allowed"); return }
        let userDefault = UserDefaults.standard
        var hasUploadedAbyssDataAccountAndSeasonMD5: [String] = userDefault
            .array(forKey: "hasUploadedAbyssDataAccountAndSeasonMD5") as? [String] ??
            []
        if let abyssData = AbyssData(account: self, which: .this) {
            print(
                "MD5 calculated by \(abyssData.uid)\(abyssData.getLocalAbyssSeason())"
            )
            let md5 = "\(abyssData.uid)\(abyssData.getLocalAbyssSeason())"
                .md5
            guard !hasUploadedAbyssDataAccountAndSeasonMD5.contains(md5)
            else {
                print(
                    "uploadAbyssData ERROR: This abyss data has uploaded.  "
                ); return
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try! encoder.encode(abyssData)
            print(String(data: data, encoding: .utf8)!)
            guard !UPLOAD_ABYSS_DATA_LOCKED
            else { print("uploadAbyssDataLocked is locked"); return }
            lock()
            API.PSAServer
                .uploadUserData(
                    path: "/abyss/upload",
                    data: data
                ) { result in
                    switch result {
                    case .success:
                        print("uploadAbyssData SUCCEED")
                        saveMD5()
                    case let .failure(error):
                        switch error {
                        case let .uploadError(message):
                            if message == "uid existed" {
                                saveMD5()
                            }
                        default:
                            break
                        }
                        print("uploadAbyssData ERROR: \(error)")
                        print(md5)
                        print(hasUploadedAbyssDataAccountAndSeasonMD5)
                    }
                    unlock()
                }
            func saveMD5() {
                hasUploadedAbyssDataAccountAndSeasonMD5.append(md5)
                userDefault.set(
                    hasUploadedAbyssDataAccountAndSeasonMD5,
                    forKey: "hasUploadedAbyssDataAccountAndSeasonMD5"
                )
                print(
                    "uploadAbyssData MD5: \(hasUploadedAbyssDataAccountAndSeasonMD5)"
                )
                userDefault.synchronize()
            }
        } else {
            print(
                "uploadAbyssData ERROR: generate data fail. Maybe because not full star."
            )
        }
        func unlock() {
            UPLOAD_ABYSS_DATA_LOCKED = false
        }
        func lock() {
            UPLOAD_ABYSS_DATA_LOCKED = true
        }
    }
    #endif
}
