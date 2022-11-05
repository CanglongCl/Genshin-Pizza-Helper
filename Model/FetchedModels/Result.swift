//
//  Result.swift
//  原神披萨小助手
//
//  Created by 戴藏龙 on 2022/8/8.
//

import Foundation

typealias FetchResult = Result<UserData, FetchError>
typealias BasicInfoFetchResult = Result<BasicInfos, FetchError>
typealias CurrentEventsFetchResult = Result<CurrentEvent, FetchError>
typealias LedgerDataFetchResult = Result<LedgerData, FetchError>
typealias AllAvatarDetailFetchResult = Result<AllAvatarDetailModel, FetchError>

#if !os(watchOS)
typealias PlayerDetailsFetchResult = Result<PlayerDetailFetchModel, RequestError>
typealias PlayerDetailResult = Result<PlayerDetail, PlayerDetail.PlayerDetailError>
typealias SpiralAbyssDetailFetchResult = Result<SpiralAbyssDetail, FetchError>
#endif

extension FetchResult {
    static let defaultFetchResult: FetchResult = .success(UserData.defaultData)
}
