//
//  PlayerDetailsModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/22.
//

import Foundation

// MARK: - PlayerDetailFetchModel

struct PlayerDetailFetchModel: Codable {
    struct PlayerInfo: Codable {
        struct ShowAvatarInfo: Codable {
            /// 角色ID
            var avatarId: Int
            /// 角色等级
            var level: Int
        }

        struct ProfilePicture: Codable {
            /// 头像对应的角色ID
            var avatarId: Int
        }

        /// 名称
        var nickname: String
        /// 等级
        var level: Int
        /// 签名
        var signature: String?
        /// 世界等级
        var worldLevel: Int
        /// 资料名片ID
        var nameCardId: Int
        /// 已解锁成就数
        var finishAchievementNum: Int
        /// 本期深渊乘数
        var towerFloorIndex: Int?
        /// 本期深渊间数
        var towerLevelIndex: Int?
        /// 正在展示角色信息列表（ID与等级）
        var showAvatarInfoList: [ShowAvatarInfo]?
        /// 正在展示名片ID的列表
        var showNameCardIdList: [Int]?
        /// 玩家头像的角色的ID: profilePicture.avatarId
        var profilePicture: ProfilePicture
    }

    struct AvatarInfo: Codable {
        struct PropMap: Codable {
            // MARK: Internal

            struct Exp: Codable {
                var type: Int
                var ival: String
            }

            struct LevelStage: Codable {
                var type: Int
                var ival: String
                var val: String?
            }

            struct Level: Codable {
                var type: Int
                var ival: String
                var val: String
            }

            var exp: Exp
            /// 等级突破
            var levelStage: LevelStage
            /// 等级
            var level: Level

            // MARK: Private

            private enum CodingKeys: String, CodingKey {
                case exp = "1001"
                case levelStage = "1002"
                case level = "4001"
            }
        }

        struct SkillLevelMap: Codable {
            // MARK: Lifecycle

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: SkillKey.self)

                var skill = [String: Int]()
                for key in container.allKeys {
                    if let model = try? container
                        .decode(Int.self, forKey: key) {
                        skill[key.stringValue] = model
                    }
                }
                self.skillLevel = skill
            }

            // MARK: Internal

            struct SkillKey: CodingKey {
                // MARK: Lifecycle

                init?(stringValue: String) {
                    self.stringValue = stringValue
                }

                init?(intValue: Int) {
                    self.stringValue = "\(intValue)"
                    self.intValue = intValue
                }

                // MARK: Internal

                var stringValue: String
                var intValue: Int?
            }

            var skillLevel: [String: Int]
        }

        /// 装备列表的一项，包括武器和圣遗物
        struct EquipList: Codable {
            /// 圣遗物
            struct Reliquary: Codable {
                /// 圣遗物等级
                var level: Int
                /// 圣遗物主属性ID
                var mainPropId: Int
                /// 圣遗物副属性ID的列表
                var appendPropIdList: [Int]?
            }

            struct Weapon: Codable {
                struct AffixMap: Codable {
                    // MARK: Lifecycle

                    init(from decoder: Decoder) throws {
                        let container = try decoder
                            .container(keyedBy: AffixKey.self)

                        var affixDict = [String: Int]()
                        for key in container.allKeys {
                            if let model = try? container.decode(
                                Int.self,
                                forKey: key
                            ) {
                                affixDict[key.stringValue] = model
                            }
                        }
                        self.affix = affixDict
                    }

                    // MARK: Internal

                    struct AffixKey: CodingKey {
                        // MARK: Lifecycle

                        init?(stringValue: String) {
                            self.stringValue = stringValue
                        }

                        init?(intValue: Int) {
                            self.stringValue = "\(intValue)"
                            self.intValue = intValue
                        }

                        // MARK: Internal

                        var stringValue: String
                        var intValue: Int?
                    }

                    var affix: [String: Int]
                }

                /// 武器等级
                var level: Int
                /// 武器突破等级
                var promoteLevel: Int?
                /// 武器精炼等级（0-4）
                var affixMap: AffixMap?
            }

            struct Flat: Codable {
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

                /// 装备名的哈希值
                var nameTextMapHash: String
                /// 圣遗物套装名称的哈希值
                var setNameTextMapHash: String?
                /// 装备稀有度
                var rankLevel: Int
                /// 圣遗物主词条
                var reliquaryMainstat: ReliquaryMainstat?
                /// 圣遗物副词条列表
                var reliquarySubstats: [ReliquarySubstat]?
                /// 武器属性列表：包括基础攻击力和副属性
                var weaponStats: [WeaponStat]?
                /// 装备类别：武器、圣遗物
                var itemType: String
                /// 装备名称图标
                var icon: String
                /// 圣遗物类型：花/羽毛/沙漏/杯子/头
                var equipType: String?
            }

            /// 物品的ID，武器和圣遗物共用
            var itemId: Int
            /// 圣遗物
            var reliquary: Reliquary?
            /// 武器
            var weapon: Weapon?
            var flat: Flat
        }

        struct FetterInfo: Codable {
            var expLevel: Int
        }

        /// 角色ID
        var avatarId: Int
        /// 命之座ID列表
        let talentIdList: [Int]?
        /// 角色属性
        var propMap: PropMap
        /// 角色战斗属性
        var fightPropMap: FightPropMap
        /// 角色天赋技能组ID
        var skillDepotId: Int
        /// 所有固定天赋ID的列表
        var inherentProudSkillList: [Int]
        /// 天赋等级的字典，skillLevelMap.skillLevel: [天赋ID(String) : 等级(Int)]
        var skillLevelMap: SkillLevelMap
        /// 装备列表，包括武器和圣遗物
        var equipList: [EquipList]
        /// 角色好感等级，fetterInfo.expLevel
        var fetterInfo: FetterInfo
        /// 命之座带来的额外技能等级加成
        var proudSkillExtraLevelMap: [String: Int]?
    }

    /// 帐号基本信息
    var playerInfo: PlayerInfo
    /// 正在展示的角色的详细信息
    var avatarInfoList: [AvatarInfo]?
    var ttl: Int?
    var uid: String?
}

// MARK: - FightPropMap

struct FightPropMap: Codable {
    // MARK: Internal

    /// 基础生命
    var baseHP: Double
    /// 基础攻击力
    var baseATK: Double
    /// 基础防御力
    var baseDEF: Double
    /// 暴击率
    var criticalRate: Double
    /// 暴击伤害
    var criticalDamage: Double
    /// 元素充能效率
    var energyRecharge: Double
    /// 治疗加成
    var healingBonus: Double
    /// 受治疗加成
    var healedBonus: Double
    /// 元素精通
    var elementalMastery: Double

    /// 物理抗性
    var physicalResistance: Double
    /// 物理伤害加成
    var physicalDamage: Double
    /// 火元素伤害加成
    var pyroDamage: Double
    /// 雷元素伤害加成
    var electroDamage: Double
    /// 水元素伤害加成
    var hydroDamage: Double
    /// 草元素伤害加成
    var dendroDamage: Double
    /// 风元素伤害加成
    var anemoDamage: Double
    /// 岩元素伤害加成
    var geoDamage: Double
    /// 冰元素伤害加成
    var cryoDamage: Double

    /// 火元素抗性
    var pyroResistance: Double
    /// 雷元素抗性
    var electroResistance: Double
    /// 水元素抗性
    var hydroResistance: Double
    /// 草元素抗性
    var dendroResistance: Double
    /// 风元素抗性
    var anemoResistance: Double
    /// 岩元素抗性
    var geoResistance: Double
    /// 冰元素抗性
    var cryoResistance: Double

    var pyroEnergyCost: Double?
    var electroEnergyCost: Double?
    var hydroEnergyCost: Double?
    var dendroEnergyCost: Double?
    var anemoEnergyCost: Double?
    var cryoEnergyCost: Double?
    var geoEnergyCost: Double?

    /// 生命值上限
    var HP: Double
    /// 攻击力
    var ATK: Double
    /// 防御力
    var DEF: Double

    // MARK: Private

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
