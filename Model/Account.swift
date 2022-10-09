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

    init(config: AccountConfiguration) {
        self.config = config
    }

    static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.config == rhs.config
    }

    var hashValue: Int {
        return config.hashValue
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
}
