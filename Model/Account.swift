//
//  Account.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/9.
//  Account所需的所有信息

import Foundation

struct Account: Equatable, Hashable {
    var config: AccountConfiguration

    // 树脂等信息
    var result: FetchResult?
    var background: WidgetBackground = WidgetBackground.randomNamecardBackground
    var basicInfo: BasicInfos?
    var fetchComplete: Bool = false

    #if !os(watchOS)
    var playerDetailResult: Result<PlayerDetail, PlayerDetail.PlayerDetailError>?
    var fetchPlayerDetailComplete: Bool = false

    // 深渊
    var spiralAbyssDetail: AccountSpiralAbyssDetail?
    // 账簿，旅行札记
    var ledgeDataResult: LedgerDataFetchResult?
    #endif

    init(config: AccountConfiguration) {
        self.config = config
    }

    static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.config == rhs.config
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(config)
    }
}

extension AccountConfiguration {
    func fetchResult(_ completion: @escaping (FetchResult) -> ()) {
        guard (uid != nil) || (cookie != nil) else { completion(.failure(.noFetchInfo)); return  }
        
        API.Features.fetchInfos(region: self.server.region,
                                serverID: self.server.id,
                                uid: self.uid!,
                                cookie: self.cookie!) { result in
            completion(result)
            #if !os(watchOS)
            switch result {
            case .success(let data):
                UserNotificationCenter.shared.createAllNotification(
                    for: self.name!,
                    with: data,
                    uid: self.uid!
                )
            case .failure(_):
                break
            }
            #endif
        }


    }

    func fetchSimplifiedResult(_ completion: @escaping (SimplifiedUserDataResult) -> ()) {
        guard let cookie = cookie else { completion(.failure(.noFetchInfo)); return }
        guard cookie.contains("stoken") else { completion(.failure(.noStoken)); return }
        API.Features.fetchSimplifiedInfos(cookie: cookie) { result in
            completion(result)
            #if !os(watchOS)
            switch result {
            case .success(let data):
                UserNotificationCenter.shared.createAllNotification(
                    for: self.name!,
                    with: data,
                    uid: self.uid!
                )
            case .failure(_):
                break
            }
            #endif
        }
    }

    func fetchBasicInfo(_ completion: @escaping (BasicInfos) -> ()) {
        API.Features.fetchBasicInfos(region: self.server.region, serverID: self.server.id, uid: self.uid ?? "", cookie: self.cookie ?? "") { result in
            switch result {
            case .success(let data) :
                completion(data)
            case .failure(_):
                print("fetching basic info error")
                break
            }
        }
    }

    #if !os(watchOS)
    func fetchPlayerDetail(dateWhenNextRefreshable: Date?, _ completion: @escaping (Result<PlayerDetailFetchModel, PlayerDetail.PlayerDetailError>) -> ()) {
        guard let uid = self.uid else { return }
        API.OpenAPIs.fetchPlayerDetail(uid, dateWhenNextRefreshable: dateWhenNextRefreshable) { result in
            completion(result)
        }
    }


    func fetchAbyssInfo(round: AbyssRound, _ completion: @escaping (SpiralAbyssDetail) -> ()) {
        // thisAbyssData
        API.Features.fetchSpiralAbyssInfos(region: self.server.region, serverID: self.server.id, uid: self.uid!, cookie: self.cookie!, scheduleType: round.rawValue) { result in
            switch result {
            case .success(let resultData):
                completion(resultData)
            case .failure(_):
                print("Fail")
            }
        }
    }

    func fetchAbyssInfo(_ completion: @escaping (AccountSpiralAbyssDetail) -> ()) {
        var this: SpiralAbyssDetail?
        var last: SpiralAbyssDetail?
        let group = DispatchGroup()
        group.enter()
        self.fetchAbyssInfo(round: .this) { data in
            this = data
            group.leave()
        }
        group.enter()
        self.fetchAbyssInfo(round: .last) { data in
            last = data
            group.leave()
        }
        group.notify(queue: .main) {
            guard let this = this, let last = last else { return }
            completion(AccountSpiralAbyssDetail(this: this, last: last))
        }
    }

    func fetchLedgerData(_ completion: @escaping (LedgerDataFetchResult) -> ()) {
        API.Features.fetchLedgerInfos(month: 0, uid: self.uid!, serverID: self.server.id, region: self.server.region, cookie: self.cookie!) { result in
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
        guard UserDefaults.standard.bool(forKey: "allowAbyssDataCollection") else { print("not allowed"); return }
        let userDefault = UserDefaults.standard
        var hasUploadedAvatarHoldingDataMD5: [String] = userDefault.array(forKey: "hasUploadedAvatarHoldingDataMD5") as? [String] ?? []
        if let avatarHoldingData = AvatarHoldingData(account: self, which: .this) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try! encoder.encode(avatarHoldingData)
            let md5 = String(data: data, encoding: .utf8)!.md5
            guard !hasUploadedAvatarHoldingDataMD5.contains(md5) else {
                print("uploadHoldingData ERROR: This holding data has uploaded. "); return
            }
            guard !UPLOAD_HOLDING_DATA_LOCKED else { print("uploadHoldingDataLocked is locked"); return }
            lock()
            API.PSAServer.uploadUserData(path: "/user_holding/upload", data: data) { result in
                switch result {
                case .success(_):
                    print("uploadHoldingData SUCCEED")
                    saveMD5()
                    print(md5)
                    print(hasUploadedAvatarHoldingDataMD5)
                case .failure(let error):
                    switch error {
                    case .uploadError(let message):
                        if message == "uid existed" || message == "Insert Failed" {
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
                userDefault.set(hasUploadedAvatarHoldingDataMD5, forKey: "hasUploadedAvatarHoldingDataMD5")
            }

        } else {
            print("uploadAbyssData ERROR: generate data fail. Maybe because not full star.")
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
        guard UserDefaults.standard.bool(forKey: "allowAbyssDataCollection") else { print("not allowed"); return }
        let userDefault = UserDefaults.standard
        var hasUploadedAbyssDataAccountAndSeasonMD5: [String] = userDefault.array(forKey: "hasUploadedAbyssDataAccountAndSeasonMD5") as? [String] ?? []
        if let abyssData = AbyssData(account: self, which: .this) {
            print("MD5 calculated by \(abyssData.uid)\(abyssData.getLocalAbyssSeason())")
            let md5 = "\(abyssData.uid)\(abyssData.getLocalAbyssSeason())".md5
            guard !hasUploadedAbyssDataAccountAndSeasonMD5.contains(md5) else {
                print("uploadAbyssData ERROR: This abyss data has uploaded.  "); return
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try! encoder.encode(abyssData)
            print(String(data: data, encoding: .utf8)!)
            guard !UPLOAD_ABYSS_DATA_LOCKED else { print("uploadAbyssDataLocked is locked"); return }
            lock()
            API.PSAServer.uploadUserData(path: "/abyss/upload", data: data) { result in
                switch result {
                case .success(_):
                    print("uploadAbyssData SUCCEED")
                    saveMD5()
                case .failure(let error):
                    switch error {
                    case .uploadError(let message):
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
                userDefault.set(hasUploadedAbyssDataAccountAndSeasonMD5, forKey: "hasUploadedAbyssDataAccountAndSeasonMD5")
                print("uploadAbyssData MD5: \(hasUploadedAbyssDataAccountAndSeasonMD5)")
                userDefault.synchronize()
            }
        } else {
            print("uploadAbyssData ERROR: generate data fail. Maybe because not full star.")
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
