//
//  BasicInfos.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/12.
//

import Foundation

struct BasicInfos: Codable {
    var stats: Stats
    var worldExplorations: [WorldExploration]
    var avatars: [Avatar]

    struct Stats: Codable {
        /// 解锁角色数
        var avatarNumber: Int
        /// 精致宝箱数
        var exquisiteChestNumber: Int
        /// 普通宝箱数
        var commonChestNumber: Int
        /// 解锁传送点数量
        var wayPointNumber: Int
        /// 岩神瞳
        var geoculusNumber: Int
        /// 草神瞳
        var dendroculusNumber: Int
        /// 解锁成就数
        var achievementNumber: Int
        /// 解锁秘境数量
        var domainNumber: Int
        /// 活跃天数
        var activeDayNumber: Int
        /// 风神瞳
        var anemoculusNumber: Int
        /// 华丽宝箱数
        var luxuriousChestNumber: Int
        /// 雷神瞳
        var electroculusNumber: Int
        /// 珍贵宝箱数
        var preciousChestNumber: Int
        /// 深境螺旋
        var spiralAbyss: String
        /// 奇馈宝箱数
        var magicChestNumber: Int
    }

    struct WorldExploration: Codable {
        var id: Int
        var backgroundImage: String
        var mapUrl: String
        var parentId: Int
        var type: String
        var offerings: [Offering]
        var level: Int
        var explorationPercentage: Int
        var icon: String
        var innerIcon: String
        var cover: String
        var name: String
        var strategyUrl: String

        struct Offering: Codable {
            var name: String
            var level: Int
            var icon: String
        }
    }

    struct Avatar: Codable, Identifiable {
        var fetter: Int
        var rarity: Int
        var cardImage: String
        var id: Int
        var isChosen: Bool
        var element: String
        var image: String
        var level: Int
        var name: String
        var activedConstellationNum: Int
    }
}
