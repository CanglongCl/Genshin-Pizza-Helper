//
//  File.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/10/5.
//

import Foundation

struct SpiralAbyssDetail: Codable {
    var energySkillRank: [CharacterRankModel]
    var startTime: String
    var totalWinTimes: Int
    var maxFloor: String
    var floors: [Floor]
    var totalBattleTimes: Int
    var takeDamageRank: [CharacterRankModel]
    var isUnlock: Bool
    var defeatRank: [CharacterRankModel]
    var endTime: String
    var normalSkillRank: [CharacterRankModel]
    var damageRank: [CharacterRankModel]
    var scheduleId: Int
    var revealRank: [CharacterRankModel]
    var totalStar: Int

    struct CharacterRankModel: Codable{
        var avatarId: Int
        var value: Int
        var avatarIcon: String
        var rarity: Int
    }

    struct Floor: Codable {
        var isUnlock: Bool
        var settleTime: String
        var star: Int
        var levels: [Level]
        var maxStar: Int
        var icon: String
        var index: Int

        struct Level: Codable {
            var star: Int
            var maxStar: Int
            var battles: [Battle]
            var index: Int

            struct Battle: Codable {
                var index: Int
                var avatars: [Avatar]
                var timestamp: String

                struct Avatar: Codable {
                    var id: Int
                    var icon: String
                    var level: Int
                    var rarity: Int
                }
            }
        }
    }
}

struct AccountSpiralAbyssDetail {
    let this: SpiralAbyssDetail
    let last: SpiralAbyssDetail
}
