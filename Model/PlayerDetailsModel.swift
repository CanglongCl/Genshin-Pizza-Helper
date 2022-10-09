//
//  PlayerDetailsModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/22.
//

import Foundation

struct PlayerDetails: Codable {
    var playerInfo: PlayerInfo
    var avatarInfoList: [AvatarInfo]?
    var ttl: Int
    var uid: String?

    struct PlayerInfo: Codable {
        var nickname: String
        var level: Int
        var signature: String
        var worldLevel: Int
        var nameCardId: Int
        var finishAchievementNum: Int
        var towerFloorIndex: Int
        var towerLevelIndex: Int
        var showAvatarInfoList: [ShowAvatarInfo]
        var showNameCardIdList: [Int]?
        var profilePicture: ProfilePicture

        struct ShowAvatarInfo: Codable {
            var avatarId: Int
            var level: Int
        }

        struct ProfilePicture: Codable {
            var avatarId: Int
        }
    }

    struct AvatarInfo: Codable {

        var avatarId: Int
        var propMap: PropMap
        var fightPropMap: FightPropMap
        var skillDepotId: Int
        var inherentProudSkillList: [Int]
        var skillLevelMap: SkillLevelMap
        var equipList: [EquipList]
        var fetterInfo: FetterInfo

        struct PropMap: Codable {
            var exp: Exp
            /// 等级突破
            var levelStage: LevelStage
            /// 等级
            var level: Level

            struct Exp: Codable {
                var type: Int
                var ival: String
            }

            struct LevelStage: Codable {
                var type: Int
                var ival: String
                var val: String
            }

            struct Level: Codable {
                var type: Int
                var ival: String
                var val: String
            }

            private enum CodingKeys: String, CodingKey {
                case exp = "1001"
                case levelStage = "1002"
                case level = "4001"
            }
        }

        struct FightPropMap: Codable {
            var baseHP: Double
            var baseATK: Double
            var baseDEF: Double
            var criticalRate: Double
            var criticalDamage: Double
            var energyRecharge: Double
            var healingBonus: Double
            var healedBonus: Double
            var elementalMastery: Double

            var physicalResistance: Double
            var physicalDamage: Double
            var pyroDamage: Double
            var electroDamage: Double
            var hydroDamage: Double
            var dendroDamage: Double
            var anemoDamage: Double
            var geoDamage: Double
            var cryoDamage: Double

            var pyroResistance: Double
            var electroResistance: Double
            var hydroResistance: Double
            var dendroResistance: Double
            var anemoResistance: Double
            var geoResistance: Double
            var cryoResistance: Double

            var pyroEnergyCost: Double?
            var electroEnergyCost: Double?
            var hydroEnergyCost: Double?
            var dendroEnergyCost: Double?
            var anemoEnergyCost: Double?
            var cryoEnergyCost: Double?
            var geoEnergyCost: Double?

            var HP: Double
            var ATK: Double
            var DEF: Double

            private enum CodingKeys: String, CodingKey {
                case baseHP = "1"
                case baseATK = "4"
                case baseDEF = "7"
                case criticalRate = "20"
                case criticalDamage = "22"
                case energyRecharge = "23"
                case healingBonus = "26"
                case healedBonus = "27"
                case elementalMastery = "28"
                case physicalResistance = "29"
                case physicalDamage = "30"
                case pyroDamage = "40"
                case electroDamage = "41"
                case hydroDamage = "42"
                case dendroDamage = "43"
                case anemoDamage = "44"
                case geoDamage = "45"
                case cryoDamage = "46"
                case pyroResistance = "50"
                case electroResistance = "51"
                case hydroResistance = "52"
                case dendroResistance = "53"
                case anemoResistance = "54"
                case geoResistance = "55"
                case cryoResistance = "56"
                case pyroEnergyCost = "70"
                case electroEnergyCost = "71"
                case hydroEnergyCost = "72"
                case dendroEnergyCost = "73"
                case anemoEnergyCost = "74"
                case cryoEnergyCost = "75"
                case geoEnergyCost = "76"
                case HP = "2000"
                case ATK = "2001"
                case DEF = "2002"
            }
        }

        struct SkillLevelMap: Codable {
            var skillLevel: [String: Int]

            struct SkillKey: CodingKey {
                var stringValue: String
                var intValue: Int?
                init?(stringValue: String) {
                    self.stringValue = stringValue
                }
                init?(intValue: Int) {
                    self.stringValue = "\(intValue)"
                    self.intValue = intValue
                }
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: SkillKey.self)

                var skill = [String: Int]()
                for key in container.allKeys {
                    if let model = try? container.decode(Int.self, forKey: key) {
                        skill[key.stringValue] = model
                    }
                }
                self.skillLevel = skill
            }
        }

        struct EquipList: Codable {
            var itemId: Int
            /// 圣遗物
            var reliquary: Reliquary?
            /// 武器
            var weapon: Weapon?
            var flat: Flat

            struct Reliquary: Codable {
                var level: Int
                var mainPropId: Int
                var appendPropIdList: [Int]
            }

            struct Weapon: Codable {
                var level: Int
                var promoteLevel: Int?
                var affixMap: AffixMap

                struct AffixMap: Codable {
                    var affix: [String: Int]

                    struct AffixKey: CodingKey {
                        var stringValue: String
                        var intValue: Int?
                        init?(stringValue: String) {
                            self.stringValue = stringValue
                        }
                        init?(intValue: Int) {
                            self.stringValue = "\(intValue)"
                            self.intValue = intValue
                        }
                    }

                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: AffixKey.self)

                        var affixDict = [String: Int]()
                        for key in container.allKeys {
                            if let model = try? container.decode(Int.self, forKey: key) {
                                affixDict[key.stringValue] = model
                            }
                        }
                        self.affix = affixDict
                    }
                }
            }

            struct Flat: Codable {
                var nameTextMapHash: String
                var setNameTextMapHash: String?
                var rankLevel: Int
                /// 圣遗物主词条
                var reliquaryMainstat: ReliquaryMainstat?
                /// 圣遗物副词条
                var reliquarySubstats: [ReliquarySubstat]?
                var weaponStats: [WeaponStat]?
                var itemType: String
                var icon: String
                var equipType: String?

                struct ReliquaryMainstat: Codable {
                    var mainPropId: String
                    var statValue: Double
                }

                struct ReliquarySubstat: Codable, Hashable {
                    var appendPropId: String
                    var statValue: Double
                }

                struct WeaponStat: Codable {
                    var appendPropId: String
                    var statValue: Double
                }
            }
        }

        struct FetterInfo: Codable {
            var expLevel: Int
        }
    }
}
