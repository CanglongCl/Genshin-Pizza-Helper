//
//  ContainGachaItemInfo.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/29.
//

import Foundation
import SwiftUI

// MARK: - ContainGachaItemInfo

protocol ContainGachaItemInfo {
    var name: String { get }
    var lang: GachaLanguageCode { get }
    var itemType: String { get }
    var _rankLevel: GachaItem.RankType { get }
    var formattedTime: String { get }
}

// MARK: - GachaItemType

enum GachaItemType {
    case character
    case weapon
}

extension GachaItemType {
    var cnRaw: String {
        switch self {
        case .character:
            return "角色"
        case .weapon:
            return "武器"
        }
    }

    static func fromRaw(_ string: String) -> Self? {
        let manager = GachaTranslateManager.shared
        let string = manager.translateItemTypeToZHCN(string)
        switch string {
        case "武器": return .weapon
        case "角色": return .character
        default: return nil
        }
    }

    // TODO: find by name
    static func findByName(_ name: String) -> Self {
        .weapon
    }

    func toLanguageRaw(_ languageCode: GachaLanguageCode) -> String {
        let manager = GachaTranslateManager.shared
        return manager.translateItemType(cnRaw, to: languageCode) ?? "武器"
    }
}

extension ContainGachaItemInfo {
    var type: GachaItemType {
        switch itemType {
        case "武器": return .weapon
        case "角色": return .character
        default: return .character
        }
    }

    var iconImageName: String {
        switch type {
        case .character:
            if let id = GachaItemNameIconMap.characterIdMap[name] {
                return "UI_AvatarIcon_\(id)"
            } else {
                // TODO: 找不到时的默认图片
                return ""
            }
        case .weapon:
            if let iconString = GachaItemNameIconMap.weaponIconNameMap[name] {
                return iconString
            } else {
                // TODO: 找不到时的默认图片
                return ""
            }
        }
    }

    var backgroundImageView: some View {
        GachaItemBackgroundImage(
            name: name,
            _itemType: type,
            _rankLevel: _rankLevel
        )
    }

    var localizedName: String {
//        guard lang != "zh-cn" else { return name }
        // TODO: 翻译为其他语言
        name.localizedWithFix
    }

    /// 显示带有背景的角色肖像图示或武器图示。
    /// - Parameters:
    ///   - size: 尺寸。
    ///   - cutType: 决定裁切到哪个身体部位。该选项对武器无效。
    /// - Returns: SwiftUI "some View"
    func decoratedIconView(_ size: CGFloat, cutTo cutType: DecoratedIconCutType = .shoulder) -> some View {
        guard type != .weapon else {
            let result = EnkaWebIcon(iconString: iconImageName)
                .scaleEffect(0.9)
                .background(backgroundImageView)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .contentShape(Circle())
            return AnyView(result)
        }
        // 由于 Lava 强烈反对针对证件照的脸裁切与头裁切，
        // 所以不预设启用该功能。
        var cutType = cutType
        if !AppConfig.cutShouldersForSmallAvatarPhotos {
            cutType = .shoulder
        }
        let result = EnkaWebIcon(iconString: iconImageName)
            .scaledToFill()
            .frame(width: size * cutType.rawValue, height: size * cutType.rawValue)
            .clipped()
            .scaledToFit()
            .offset(y: cutType.shiftedAmount(containerSize: size))
            .background(backgroundImageView)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .contentShape(Circle())
        return AnyView(result)
    }
}

// MARK: - GachaItemBackgroundImage

struct GachaItemBackgroundImage: View {
    let name: String
    let _itemType: GachaItemType
    let _rankLevel: GachaItem.RankType

    var imageString: String {
        switch _itemType {
        case .character:
            if let id = GachaItemNameIconMap.characterIdMap[name] {
                if id == "Yae" {
                    return "UI_NameCardPic_Yae1_P"
                } else {
                    return "UI_NameCardPic_\(id)_P"
                }
            } else {
                // TODO: 找不到时的默认图片
                return ""
            }
        case .weapon:
            return "UI_QualityBg_\(_rankLevel.rawValue)"
        }
    }

    var body: some View {
        switch _itemType {
        case .character:
            EnkaWebIcon(iconString: imageString).scaledToFill()
                .offset(x: -30 / 3)
        case .weapon:
            if _rankLevel.rawValue == 3 {
                EnkaWebIcon(
                    iconString: imageString
                )
                .scaledToFit()
                .scaleEffect(2)
                .offset(y: 3)
            } else {
                EnkaWebIcon(
                    iconString: imageString
                )
                .scaledToFit()
                .scaleEffect(1.5)
                .offset(y: 3)
            }
        }
    }
}

// MARK: - GachaItemNameIconMap

enum GachaItemNameIconMap {
    static var weaponIconNameMap: [String: String] {
        [
            "「高塔孤王」": "weapon.Decarabian",
            "西风剑": "UI_EquipIcon_Sword_Zephyrus_Awaken",
            "宗室长剑": "UI_EquipIcon_Sword_Theocrat_Awaken",
            "暗巷闪光": "UI_EquipIcon_Sword_Outlaw_Awaken",
            "辰砂之纺锤": "UI_EquipIcon_Sword_Opus_Awaken",
            "风鹰剑": "UI_EquipIcon_Sword_Falcon_Awaken",
            "钟剑": "UI_EquipIcon_Claymore_Troupe_Awaken",
            "雪葬的星银": "UI_EquipIcon_Claymore_Dragonfell_Awaken",
            "松籁响起之时": "UI_EquipIcon_Claymore_Widsith_Awaken",
            "西风秘典": "UI_EquipIcon_Catalyst_Zephyrus_Awaken",
            "宗室秘法录": "UI_EquipIcon_Catalyst_Theocrat_Awaken",
            "绝弦": "UI_EquipIcon_Bow_Troupe_Awaken",
            "苍翠猎弓": "UI_EquipIcon_Bow_Viridescent_Awaken",
            "幽夜华尔兹": "UI_EquipIcon_Bow_Nachtblind_Awaken",
            "「凛风奔狼」": "weapon.BorealWolf",
            "天空之卷": "UI_EquipIcon_Catalyst_Dvalin_Awaken",
            "天空之刃": "UI_EquipIcon_Sword_Dvalin_Awaken",
            "天空之翼": "UI_EquipIcon_Bow_Dvalin_Awaken",
            "终末嗟叹之诗": "UI_EquipIcon_Bow_Widsith_Awaken",
            "流浪乐章": "UI_EquipIcon_Catalyst_Troupe_Awaken",
            "祭礼弓": "UI_EquipIcon_Bow_Fossil_Awaken",
            "笛剑": "UI_EquipIcon_Sword_Troupe_Awaken",
            "祭礼大剑": "UI_EquipIcon_Claymore_Fossil_Awaken",
            "黑剑": "UI_EquipIcon_Sword_Bloodstained_Awaken",
            "决斗之枪": "UI_EquipIcon_Pole_Gladiator_Awaken",
            "龙脊长枪": "UI_EquipIcon_Pole_Everfrost_Awaken",
            "暗巷的酒与诗": "UI_EquipIcon_Catalyst_Outlaw_Awaken",
            "嘟嘟可故事集": "UI_EquipIcon_Catalyst_Ludiharpastum_Awaken",
            "降临之剑": "UI_EquipIcon_Sword_Psalmus_Awaken",
            "天空之傲": "UI_EquipIcon_Claymore_Dvalin_Awaken",
            "风信之锋": "UI_EquipIcon_Pole_Windvane_Awaken",
            "「狮牙斗士」": "weapon.DandelionGladiator",
            "祭礼剑": "UI_EquipIcon_Sword_Fossil_Awaken",
            "腐殖之剑": "UI_EquipIcon_Sword_Magnum_Awaken",
            "苍古自由之誓": "UI_EquipIcon_Sword_Widsith_Awaken",
            "西风大剑": "UI_EquipIcon_Claymore_Zephyrus_Awaken",
            "宗室大剑": "UI_EquipIcon_Claymore_Theocrat_Awaken",
            "狼的末路": "UI_EquipIcon_Claymore_Wolfmound_Awaken",
            "西风长枪": "UI_EquipIcon_Pole_Zephyrus_Awaken",
            "天空之脊": "UI_EquipIcon_Pole_Dvalin_Awaken",
            "祭礼残章": "UI_EquipIcon_Catalyst_Fossil_Awaken",
            "忍冬之果": "UI_EquipIcon_Catalyst_Everfrost_Awaken",
            "四风原典": "UI_EquipIcon_Catalyst_Fourwinds_Awaken",
            "西风猎弓": "UI_EquipIcon_Bow_Zephyrus_Awaken",
            "宗室长弓": "UI_EquipIcon_Bow_Theocrat_Awaken",
            "暗巷猎手": "UI_EquipIcon_Bow_Outlaw_Awaken",
            "风花之颂": "UI_EquipIcon_Bow_Exotic_Awaken",
            "阿莫斯之弓": "UI_EquipIcon_Bow_Amos_Awaken",
            "饰铁之花": "UI_EquipIcon_Claymore_Fleurfair_Awaken",
            "「孤云寒林」": "weapon.Guyun",
            "匣里龙吟": "UI_EquipIcon_Sword_Rockkiller_Awaken",
            "黑岩长剑": "UI_EquipIcon_Sword_Blackrock_Awaken",
            "斫峰之刃": "UI_EquipIcon_Sword_Kunwu_Awaken",
            "白影剑": "UI_EquipIcon_Claymore_Exotic_Awaken",
            "千岩古剑": "UI_EquipIcon_Claymore_Lapis_Awaken",
            "流月针": "UI_EquipIcon_Pole_Exotic_Awaken",
            "和璞鸢": "UI_EquipIcon_Pole_Morax_Awaken",
            "匣里日月": "UI_EquipIcon_Catalyst_Resurrection_Awaken",
            "黑岩绯玉": "UI_EquipIcon_Catalyst_Blackrock_Awaken",
            "弓藏": "UI_EquipIcon_Bow_Recluse_Awaken",
            "黑岩战弓": "UI_EquipIcon_Bow_Blackrock_Awaken",
            "若水": "UI_EquipIcon_Bow_Kirin_Awaken",
            "「雾海云间」": "weapon.MistVeiled",
            "试作斩岩": "UI_EquipIcon_Sword_Proto_Awaken",
            "磐岩结绿": "UI_EquipIcon_Sword_Morax_Awaken",
            "雨裁": "UI_EquipIcon_Claymore_Perdue_Awaken",
            "黑岩斩刀": "UI_EquipIcon_Claymore_Blackrock_Awaken",
            "无工之剑": "UI_EquipIcon_Claymore_Kunwu_Awaken",
            "匣里灭辰": "UI_EquipIcon_Pole_Stardust_Awaken",
            "黑岩刺枪": "UI_EquipIcon_Pole_Blackrock_Awaken",
            "宗室猎枪": "UI_EquipIcon_Pole_Theocrat_Awaken",
            "息灾": "UI_EquipIcon_Pole_Santika_Awaken",
            "试作金珀": "UI_EquipIcon_Catalyst_Proto_Awaken",
            "昭心": "UI_EquipIcon_Catalyst_Truelens_Awaken",
            "「漆黑陨铁」": "weapon.Aerosiderite",
            "铁蜂刺": "UI_EquipIcon_Sword_Exotic_Awaken",
            "试作古华": "UI_EquipIcon_Claymore_Proto_Awaken",
            "螭骨剑": "UI_EquipIcon_Claymore_Kione_Awaken",
            "衔珠海皇": "UI_EquipIcon_Claymore_MillenniaTuna_Awaken",
            "试作星镰": "UI_EquipIcon_Pole_Proto_Awaken",
            "千岩长枪": "UI_EquipIcon_Pole_Lapis_Awaken",
            "护摩之杖": "UI_EquipIcon_Pole_Homa_Awaken",
            "贯虹之槊": "UI_EquipIcon_Pole_Kunwu_Awaken",
            "万国诸海图谱": "UI_EquipIcon_Catalyst_Exotic_Awaken",
            "尘世之锁": "UI_EquipIcon_Catalyst_Kunwu_Awaken",
            "钢轮弓": "UI_EquipIcon_Bow_Exotic_Awaken",
            "落霞": "UI_EquipIcon_Bow_Fallensun_Awaken",
            "「远海夷地」": "weapon.DistantSea",
            "天目影打刀": "UI_EquipIcon_Sword_Bakufu_Awaken",
            "雾切之回光": "UI_EquipIcon_Sword_Narukami_Awaken",
            "恶王丸": "UI_EquipIcon_Claymore_Maria_Awaken",
            "白辰之环": "UI_EquipIcon_Catalyst_Bakufu_Awaken",
            "证誓之明瞳": "UI_EquipIcon_Catalyst_Jyanome_Awaken",
            "不灭月华": "UI_EquipIcon_Catalyst_Kaleido_Awaken",
            "「鸣神御灵」": "weapon.Narukami",
            "波乱月白经津": "UI_EquipIcon_Sword_Amenoma_Awaken",
            "桂木斩长正": "UI_EquipIcon_Claymore_Bakufu_Awaken",
            "赤角石溃杵": "UI_EquipIcon_Claymore_Itadorimaru_Awaken",
            "破魔之弓": "UI_EquipIcon_Bow_Bakufu_Awaken",
            "掠食者": "UI_EquipIcon_Bow_Predator_Awaken",
            "曚云之月": "UI_EquipIcon_Bow_Maria_Awaken",
            "飞雷之弦振": "UI_EquipIcon_Bow_Narukami_Awaken",
            "东花坊时雨": "UI_EquipIcon_Sword_Kasabouzu_Awaken",
            "「今昔剧画」": "weapon.Kijin",
            "笼钓瓶一心": "UI_EquipIcon_Sword_Youtou_Awaken",
            "喜多院十文字": "UI_EquipIcon_Pole_Bakufu_Awaken",
            "「渔获」": "UI_EquipIcon_Pole_Mori_Awaken",
            "断浪长鳍": "UI_EquipIcon_Pole_Maria_Awaken",
            "薙草之稻光": "UI_EquipIcon_Pole_Narukami_Awaken",
            "神乐之真意": "UI_EquipIcon_Catalyst_Narukami_Awaken",
            "冬极白星": "UI_EquipIcon_Bow_Worldbane_Awaken",
            "「谧林涓露」": "weapon.ForestDew",
            "原木刀": "UI_EquipIcon_Sword_Arakalari_Awaken",
            "西福斯的月光": "UI_EquipIcon_Sword_Pleroma_Awaken",
            "圣显之钥": "UI_EquipIcon_Sword_Deshret_Awaken",
            "森林王器": "UI_EquipIcon_Claymore_Arakalari_Awaken",
            "裁叶萃光": "UI_EquipIcon_Sword_Ayus_Awaken",
            "「绿洲花园」": "weapon.OasisGarden",
            "贯月矢": "UI_EquipIcon_Pole_Arakalari_Awaken",
            "赤沙之杖": "UI_EquipIcon_Pole_Deshret_Awaken",
            "流浪的晚星": "UI_EquipIcon_Catalyst_Pleroma_Awaken",
            "盈满之实": "UI_EquipIcon_Catalyst_Arakalari_Awaken",
            "千夜浮梦": "UI_EquipIcon_Catalyst_Ayus_Awaken",
            "「烈日威权」": "weapon.ScorchingMight",
            "玛海菈的水色": "UI_EquipIcon_Claymore_Pleroma_Awaken",
            "王下近侍": "UI_EquipIcon_Bow_Arakalari_Awaken",
            "竭泽": "UI_EquipIcon_Bow_Fin_Awaken",
            "猎人之径": "UI_EquipIcon_Bow_Ayus_Awaken",
            "图莱杜拉的回忆": "UI_EquipIcon_Catalyst_Alaya_Awaken",
            "苇海信标": "UI_EquipIcon_Claymore_Deshret_Awaken",
            "冷刃": "UI_EquipIcon_Sword_Steel_Awaken",
            "黎明神剑": "UI_EquipIcon_Sword_Dawn_Awaken",
            "旅行剑": "UI_EquipIcon_Sword_Traveler_Awaken",
            "暗铁剑": "UI_EquipIcon_Sword_Darker_Awaken",
            "吃虎鱼刀": "UI_EquipIcon_Sword_Sashimi_Awaken",
            "飞天御剑": "UI_EquipIcon_Sword_Mitsurugi_Awaken",
            "铁影阔剑": "UI_EquipIcon_Claymore_Glaive_Awaken",
            "沐浴龙血的剑": "UI_EquipIcon_Claymore_Siegfry_Awaken",
            "白铁大剑": "UI_EquipIcon_Claymore_Tin_Awaken",
            "石英大剑": "UI_EquipIcon_Claymore_Quartz_Awaken",
            "以理服人": "UI_EquipIcon_Claymore_Reasoning_Awaken",
            "飞天大御剑": "UI_EquipIcon_Claymore_Mitsurugi_Awaken",
            "白缨枪": "UI_EquipIcon_Pole_Ruby_Awaken",
            "钺矛": "UI_EquipIcon_Pole_Halberd_Awaken",
            "黑缨枪": "UI_EquipIcon_Pole_Noire_Awaken",
            "「旗杆」": "UI_EquipIcon_Pole_Flagpole_Awaken",
            "魔导绪论": "UI_EquipIcon_Catalyst_Intro_Awaken",
            "讨龙英杰谭": "UI_EquipIcon_Catalyst_Pulpfic_Awaken",
            "异世界行记": "UI_EquipIcon_Catalyst_Lightnov_Awaken",
            "翡玉法球": "UI_EquipIcon_Catalyst_Jade_Awaken",
            "甲级宝珏": "UI_EquipIcon_Catalyst_Phoney_Awaken",
            "琥珀玥": "UI_EquipIcon_Catalyst_Amber_Awaken",
            "鸦羽弓": "UI_EquipIcon_Bow_Crowfeather_Awaken",
            "神射手之誓": "UI_EquipIcon_Bow_Arjuna_Awaken",
            "反曲弓": "UI_EquipIcon_Bow_Curve_Awaken",
            "弹弓": "UI_EquipIcon_Bow_Sling_Awaken",
            "信使": "UI_EquipIcon_Bow_Msg_Awaken",
            "黑檀弓": "UI_EquipIcon_Bow_Hardwood_Awaken",
            "碧落之珑": "UI_EquipIcon_Catalyst_Morax_Awaken",
        ]
    }

    static var characterIdMap: [String: String] {
        [
            "芭芭拉": "Barbara",
            "安柏": "Ambor",
            "可莉": "Klee",
            "达达利亚": "Tartaglia",
            "迪奥娜": "Diona",
            "砂糖": "Sucrose",
            "埃洛伊": "Aloy",
            "莫娜": "Mona",
            "琴": "Qin",
            "优菈": "Eula",
            "迪卢克": "Diluc",
            "雷泽": "Razor",
            "诺艾尔": "Noel",
            "班尼特": "Bennett",
            "丽莎": "Lisa",
            "菲谢尔": "Fischl",
            "凯亚": "Kaeya",
            "温迪": "Venti",
            "阿贝多": "Albedo",
            "罗莎莉亚": "Rosaria",
            "米卡": "Mika",
            "魈": "Xiao",
            "凝光": "Ningguang",
            "七七": "Qiqi",
            "刻晴": "Keqing",
            "夜兰": "Yelan",
            "申鹤": "Shenhe",
            "香菱": "Xiangling",
            "重云": "Chongyun",
            "甘雨": "Ganyu",
            "胡桃": "Hutao",
            "枫原万叶": "Kazuha",
            "云堇": "Yunjin",
            "瑶瑶": "Yaoyao",
            "北斗": "Beidou",
            "行秋": "Xingqiu",
            "钟离": "Zhongli",
            "辛焱": "Xinyan",
            "烟绯": "Feiyan",
            "宵宫": "Yoimiya",
            "托马": "Tohma",
            "珊瑚宫心海": "Kokomi",
            "鹿野院平藏": "Heizo",
            "九条裟罗": "Sara",
            "神里绫华": "Ayaka",
            "荒泷一斗": "Itto",
            "久岐忍": "Shinobu",
            "神里绫人": "Ayato",
            "雷电将军": "Shougun",
            "早柚": "Sayu",
            "五郎": "Gorou",
            "八重神子": "Yae",
            "提纳里": "Tighnari",
            "坎蒂丝": "Candace",
            "赛诺": "Cyno",
            "珐露珊": "Faruzan",
            "多莉": "Dori",
            "纳西妲": "Nahida",
            "莱依拉": "Layla",
            "艾尔海森": "Alhatham",
            "柯莱": "Collei",
            "妮露": "Nilou",
            "流浪者": "Wanderer",
            "迪希雅": "Dehya",
            "卡维": "Kaveh",
            "白术": "Baizhuer",
        ]
    }
}
