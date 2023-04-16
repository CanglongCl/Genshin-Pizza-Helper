//
//  TeamUtilizationData.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/10/30.
//

import Foundation

// MARK: - TeamUtilizationData

struct TeamUtilizationData: Codable {
    struct Team: Codable {
        let team: [Int]
        let percentage: Double
    }

    let totalUsers: Int
    let teams: [Team]
    let teamsFH: [Team]
    let teamsSH: [Team]
}

typealias TeamUtilizationDataFetchModelResult =
    FetchHomeModelResult<TeamUtilizationData>
typealias TeamUtilizationDataFetchModel = FetchHomeModel<TeamUtilizationData>
