//
//  File.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/10/5.
//

import Foundation

struct SpiralAbyssDetail: Codable {
    /// 元素爆发排名（只有第一个）
    var energySkillRank: [CharacterRankModel]
    /// 本期深渊开始时间
    var startTime: String
    /// 总胜利次数
    var totalWinTimes: Int
    /// 到达最高层间数（最深抵达），eg "12-3"
    var maxFloor: String
    /// 各楼层数据
    var floors: [Floor]
    /// 总挑战次数
    var totalBattleTimes: Int
    /// 最高承受伤害排名（只有最高）
    var takeDamageRank: [CharacterRankModel]
    /// 是否解锁深渊
    var isUnlock: Bool
    /// 最多击败敌人数量排名（只有最高
    var defeatRank: [CharacterRankModel]
    /// 本期深渊结束时间
    var endTime: String
    /// 元素战记伤害排名（只有最高）
    var normalSkillRank: [CharacterRankModel]
    /// 元素战记伤害排名（只有最高）
    var damageRank: [CharacterRankModel]
    /// 深渊期数ID，每期+1
    var scheduleId: Int
    /// 出站次数
    var revealRank: [CharacterRankModel]
    var totalStar: Int

    struct CharacterRankModel: Codable{
        /// 角色ID
        var avatarId: Int
        /// 排名对应的值
        var value: Int
        /// 角色头像
        var avatarIcon: String
        /// 角色星级（4/5）
        var rarity: Int
    }

    struct Floor: Codable {
        /// 是否解锁
        var isUnlock: Bool
        /// ？
        var settleTime: String
        /// 本层星数
        var star: Int
        /// 各间数据
        var levels: [Level]
        /// 满星数（=9）
        var maxStar: Int
        /// 废弃
        var icon: String
        /// 第几层，楼层序数（9,10,11,12）
        var index: Int
        /// 是否满星
        var gainAllStar: Bool {
            star == maxStar
        }

        struct Level: Codable {
            /// 本间星数
            var star: Int
            /// 本间满星数（3）
            var maxStar: Int
            /// 上半间与下半间
            var battles: [Battle]
            /// 本间序数，第几件
            var index: Int

            struct Battle: Codable {
                /// 半间序数，1为上半，2为下半
                var index: Int
                /// 出战角色
                var avatars: [Avatar]
                /// 完成时间戳since1970
                var timestamp: String

                struct Avatar: Codable {
                    /// 角色ID
                    var id: Int
                    /// 角色头像
                    var icon: String
                    /// 角色等级
                    var level: Int
                    /// 角色星级
                    var rarity: Int
                }
            }
        }
    }
}

struct AccountSpiralAbyssDetail {
    let this: SpiralAbyssDetail
    let last: SpiralAbyssDetail

    enum WhichSeason {
        case this
        case last
    }
    func get(_ whichSeason: WhichSeason) -> SpiralAbyssDetail {
        switch whichSeason {
        case .this:
            return this
        case .last:
            return last
        }
    }
}
