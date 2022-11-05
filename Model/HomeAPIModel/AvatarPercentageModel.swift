//
//  AvatarRateModel.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/21.
//

import Foundation

struct AvatarPercentageModel: Codable {
    let totalUsers: Int
    let avatars: [Avatar]

    struct Avatar: Codable {
        let charId: Int
        let percentage: Double?
    }
}
