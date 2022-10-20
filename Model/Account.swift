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
        guard (uid != nil) || (cookie != nil) else { return }
        
        API.Features.fetchInfos(region: self.server.region,
                                serverID: self.server.id,
                                uid: self.uid!,
                                cookie: self.cookie!)
        { completion($0) }
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
