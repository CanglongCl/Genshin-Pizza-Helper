//
//  PlayerDetail.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/10/3.
//

import Foundation

struct PlayerDetail {
    let nextRefreshableDate: Date

    let basicInfo: PlayerBasicInfo

    let avatars: [Avatar]

    // MARK: - 初始化
    init(playerDetailFetchModel: PlayerDetailFetchModel, localizedDictionary: [String : String], characterMap: [String: ENCharacterMap.Character]) {
        basicInfo = .init(playerInfo: playerDetailFetchModel.playerInfo, characterMap: characterMap)
        if let avatarInfoList = playerDetailFetchModel.avatarInfoList {
            avatars = avatarInfoList.compactMap { avatarInfo in
                    .init(avatarInfo: avatarInfo, localizedDictionary: localizedDictionary, characterDictionary: characterMap)
            }
        } else { avatars = .init() }
        nextRefreshableDate = Calendar.current.date(byAdding: .second, value: playerDetailFetchModel.ttl ?? 30, to: Date())!
    }

    // MARK: - 本地化工具及其他词典


    // MARK: - Model
    /// 账号基本信息
    struct PlayerBasicInfo {
        /// 名称
        var nickname: String
        /// 等级
        var level: Int
        /// 签名
        var signature: String
        /// 世界等级
        var worldLevel: Int

        /// 资料名片ID
        var nameCardId: Int
        /// 玩家头像
        var profilePictureAvatarIconString: String

        /// 正在展示的名片
        var showingNameCards: [Int]

        init(playerInfo: PlayerDetailFetchModel.PlayerInfo, characterMap: [String: ENCharacterMap.Character]) {
            nickname = playerInfo.nickname
            level = playerInfo.level
            signature = playerInfo.signature ?? ""
            worldLevel = playerInfo.worldLevel
            nameCardId = playerInfo.nameCardId
            profilePictureAvatarIconString = characterMap["\(playerInfo.profilePicture.avatarId)"]?.SideIconName.replacingOccurrences(of: "_Side", with: "") ?? ""
            showingNameCards = playerInfo.showNameCardIdList ?? []
        }
    }

    /// 游戏角色
    struct Avatar: Hashable {
        /// 名字
        let name: String
        /// 元素
        let element: AvatarElement
        /// 命之座等级 (0-6)
        let talentCount: Int
        /// 天赋
        let skills: [Skill]

        /// 等级
        let level: Int

        /// 武器
        let weapon: Weapon
        /// 圣遗物
        let artifacts: [Artifact]

        /// 角色属性
        let fightPropMap: FightPropMap

        /// 英文名ID（用于图标）
        private var nameID: String { iconString.replacingOccurrences(of: "UI_AvatarIcon_", with: "")}
        /// 正脸图
        let iconString: String
        /// 侧脸图
        let sideIconString: String
        /// 名片
        var namecardIconString: String {
            // 主角没有对应名片
            if nameID == "PlayerGirl" || nameID == "PlayerBoy" {
                return "UI_NameCardPic_Bp2_P"
            } else if nameID == "Yae" {
                return "UI_NameCardPic_Yae1_P"
            } else {
                return "UI_NameCardPic_\(nameID)_P"
            }
        }

        let quality: Quality

        init?(avatarInfo: PlayerDetailFetchModel.AvatarInfo, localizedDictionary: [String : String], characterDictionary: [String : ENCharacterMap.Character]) {
            guard let character = characterDictionary["\(avatarInfo.avatarId)"] else { return nil }

            name = localizedDictionary.nameFromHashMap(character.NameTextMapHash)
            element = AvatarElement.init(rawValue: character.Element) ?? .unknow

            if let talentIdList = avatarInfo.talentIdList {
                talentCount = talentIdList.count
            } else {
                talentCount = 0
            }

            iconString = character.SideIconName.replacingOccurrences(of: "_Side", with: "")
            sideIconString = character.SideIconName

            skills = character.SkillOrder.map({ skillID in
                let level = avatarInfo.skillLevelMap.skillLevel.first { key, value in
                    key == String(skillID)
                }?.value ?? 0
                let icon = character.Skills.skillData[String(skillID)] ?? "unknow"
                return Skill(name: localizedDictionary.nameFromHashMap(skillID), level: level, iconString: icon)
            })

            guard let weaponEquipment = avatarInfo.equipList.first(where: { equipment in
                equipment.flat.itemType == "ITEM_WEAPON"
            }) else { return nil }
            weapon = .init(weaponEquipment: weaponEquipment, localizedDictionary: localizedDictionary)!

            artifacts = avatarInfo.equipList.filter({ equip in
                equip.flat.itemType == "ITEM_RELIQUARY"
            }).compactMap({ artifactEquipment in
                    .init(artifactEquipment: artifactEquipment, localizedDictionary: localizedDictionary)
            })

            fightPropMap = avatarInfo.fightPropMap

            level = Int(avatarInfo.propMap.level.val) ?? 0
            quality = .init(rawValue: character.QualityType) ?? .purple
        }

        // Model
        /// 天赋
        struct Skill {
            /// 天赋名字(字典没有，暂时无法使用)
            let name: String
            /// 天赋等级
            let level: Int
            /// 天赋图标ID
            let iconString: String
        }
        /// 武器
        struct Weapon {
            /// 武器名字
            let name: String
            /// 武器等级
            let level: Int
            /// 精炼等阶 (1-5)
            let refinementRank: Int
            /// 武器主属性
            let mainAttribute: Attribute
            /// 武器副属性
            let subAttribute: Attribute?
            /// 武器图标ID
            let iconString: String
            /// 突破后武器图标ID
            var awakenedIconString: String { "\(iconString)_Awaken"}

            /// 武器星级
            let rankLevel: RankLevel

            init?(weaponEquipment: PlayerDetailFetchModel.AvatarInfo.EquipList, localizedDictionary: [String : String]) {
                guard weaponEquipment.flat.itemType == "ITEM_WEAPON" else { return nil }
                name = localizedDictionary.nameFromHashMap(weaponEquipment.flat.nameTextMapHash)
                level = weaponEquipment.weapon!.level
                refinementRank = (weaponEquipment.weapon!.affixMap?.affix.first?.value ?? 0) + 1

                let mainAttributeName: String = PropertyDictionary.getLocalizedName("FIGHT_PROP_BASE_ATTACK")
                let mainAttributeValue: Double = weaponEquipment.flat.weaponStats?.first(where: { stats in
                    stats.appendPropId == "FIGHT_PROP_BASE_ATTACK"
                })?.statValue ?? 0
                mainAttribute = .init(name: mainAttributeName, value: mainAttributeValue)

                if weaponEquipment.flat.weaponStats?.first(where: { stats in
                    stats.appendPropId != "FIGHT_PROP_BASE_ATTACK"
                }) != nil {
                    let subAttributeName: String = PropertyDictionary.getLocalizedName(weaponEquipment.flat.weaponStats?.first(where: { stats in
                        stats.appendPropId != "FIGHT_PROP_BASE_ATTACK"
                    })?.appendPropId ?? "")
                    let subAttributeValue: Double = weaponEquipment.flat.weaponStats?.first(where: { stats in
                        stats.appendPropId != "FIGHT_PROP_BASE_ATTACK"
                    })?.statValue ?? 0
                    subAttribute = .init(name: subAttributeName, value: subAttributeValue)
                } else {
                    subAttribute = nil
                }

                iconString = weaponEquipment.flat.icon

                rankLevel = .init(rawValue: weaponEquipment.flat.rankLevel) ?? .four
            }
        }
        /// 圣遗物
        struct Artifact: Identifiable, Equatable {
            static func == (lhs: PlayerDetail.Avatar.Artifact, rhs: PlayerDetail.Avatar.Artifact) -> Bool {
                lhs.id == rhs.id
            }

            let id: String

            /// 圣遗物名字（词典没有，暂不可用）
            let name: String
            /// 所属圣遗物套装的名字
            let setName: String
            /// 圣遗物的主属性
            let mainAttribute: Attribute
            /// 圣遗物的副属性
            let subAttributes: [Attribute]
            /// 圣遗物图标ID
            let iconString: String
            /// 圣遗物所属部位
            let artifactType: ArtifactType

            /// 圣遗物星级
            let rankLevel: RankLevel

            enum ArtifactType: String, CaseIterable {
                case flower = "EQUIP_BRACER"
                case plume = "EQUIP_NECKLACE"
                case sand = "EQUIP_SHOES"
                case goblet = "EQUIP_RING"
                case circlet = "EQUIP_DRESS"
            }

            init?(artifactEquipment: PlayerDetailFetchModel.AvatarInfo.EquipList, localizedDictionary: [String : String]) {
                guard artifactEquipment.flat.itemType == "ITEM_RELIQUARY" else { return nil }
                id = artifactEquipment.flat.nameTextMapHash
                name = localizedDictionary.nameFromHashMap(artifactEquipment.flat.nameTextMapHash)
                setName = localizedDictionary.nameFromHashMap(artifactEquipment.flat.setNameTextMapHash!)
                mainAttribute = Attribute(name: PropertyDictionary.getLocalizedName(artifactEquipment.flat.reliquaryMainstat!.mainPropId), value: artifactEquipment.flat.reliquaryMainstat!.statValue)
                subAttributes = artifactEquipment.flat.reliquarySubstats?.map({ stats in
                    Attribute(name: PropertyDictionary.getLocalizedName(stats.appendPropId), value: stats.statValue)
                }) ?? []
                iconString = artifactEquipment.flat.icon
                artifactType = .init(rawValue: artifactEquipment.flat.equipType ?? "") ?? .flower
                rankLevel = .init(rawValue: artifactEquipment.flat.rankLevel) ?? .five
            }
        }
        /// 任意属性
        struct Attribute {
            let name: String
            var valueString: String {
                get {
                    if floor(value) == value {
                        return "\(Int(value))"
                    } else {
                        return String(format: "%.1f", value)
                    }
                }
            }
            var value: Double
            init(name: String, value: Double) {
                self.name = name
                self.value = value
            }
            /// 属性图标的ID
//            let iconString: String
        }
        /// 元素类型
        enum AvatarElement: String {
            case ice = "Ice"
            case wind = "Wind"
            case electric = "Electric"
            case water = "Water"
            case fire = "Fire"
            case rock = "Rock"
            case grass = "Grass"
            case unknow
        }
        /// 角色星级，橙色为四星，紫色为五星
        enum Quality: String {
            /// 紫色，四星角色
            case purple = "QUALITY_PURPLE"
            /// 橙色，五星角色
            case orange = "QUALITY_ORANGE"
            /// 特殊橙色，埃洛伊
            case orangeSpecial = "QUALITY_ORANGE_SP"
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
        static func == (lhs: PlayerDetail.Avatar, rhs: PlayerDetail.Avatar) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }

    enum PlayerDetailError: Error {
        case failToGetLocalizedDictionary
        case failToGetCharacterDictionary
        case failToGetCharacterData(message: String)
        case refreshTooFast(dateWhenRefreshable: Date)
    }
}

private extension Dictionary where Key == String, Value == String {
    func nameFromHashMap(_ hashID: Int) -> String {
        self["\(hashID)"] ?? "unknow"
    }
    func nameFromHashMap(_ hashID: String) -> String {
        self[hashID] ?? "unknow"
    }
}

enum RankLevel: Int {
    case one = 1, two = 2, three = 3, four = 4, five = 5
    var rectangularBackgroundIconString: String {
        "UI_QualityBg_\(self.rawValue)"
    }
    var squaredBackgroundIconString: String {
        "UI_QualityBg_\(self.rawValue)s"
    }
}
