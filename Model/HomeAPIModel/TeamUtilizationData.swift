//
//  TeamUtilizationData.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/10/30.
//

import Foundation

struct TeamUtilizationData: Codable {
    let totalUsers: Int
    let teams: [Team]
    let teamsFH: [Team]
    let teamsSH: [Team]

    struct Team: Codable {
        let team: [Int]
        let percentage: Double
    }
}

typealias TeamUtilizationDataFetchModelResult = FetchHomeModelResult<TeamUtilizationData>
typealias TeamUtilizationDataFetchModel = FetchHomeModel<TeamUtilizationData>
