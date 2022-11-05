//
//  AllAvatarDetailModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/10/21.
//

import Foundation

struct AllAvatarDetailModel: Codable {
    var avatars: [Avatar]

    struct Avatar: Codable, Equatable {
        static func == (lhs: AllAvatarDetailModel.Avatar, rhs: AllAvatarDetailModel.Avatar) -> Bool {
            lhs.id == rhs.id
        }

        var id: Int
        var element: String
        var costumes: [Costume]
        var reliquaries: [Reliquary]
        var level: Int
        var image: String
        var icon: String
        var weapon: Weapon
        var fetter: Int
        var constellations: [Constellation]
        var activedConstellationNum: Int
        var name: String
        var rarity: Int

        struct Costume: Codable {
            var id: Int
            var name: String
            var icon: String
        }

        struct Reliquary: Codable {
            var pos: Int
            var rarity: Int
            var set: Set
            var id: Int
            var posName: String
            var level: Int
            var name: String
            var icon: String

            struct Set: Codable {
                var id: Int
                var name: String
                var affixes: [Affix]

                struct Affix: Codable {
                    var activationNumber: Int
                    var effect: String
                }
            }
        }

        struct Weapon: Codable {
            var rarity: Int
            var icon: String
            var id: Int
            var typeName: String
            var level: Int
            var affixLevel: Int
            var type: Int
            var promoteLevel: Int
            var desc: String
        }

        struct Constellation: Codable {
            var effect: String
            var id: Int
            var icon: String
            var name: String
            var pos: Int
            var isActived: Bool
        }
    }
}
