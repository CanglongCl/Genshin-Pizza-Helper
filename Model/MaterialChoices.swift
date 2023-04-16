//
//  MaterialChoices.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/20.
//

import Foundation

extension WeaponOrTalentMaterial {
    // MARK: - Weapon Material choices

    // 蒙德
    static let decarabian: WeaponOrTalentMaterial = .init(
        imageString: "weapon.Decarabian",
        nameToLocalize: "「高塔孤王」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Zephyrus_Awaken",
                nameToLocalize: "西风剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Theocrat_Awaken",
                nameToLocalize: "宗室长剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Outlaw_Awaken",
                nameToLocalize: "暗巷闪光"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Opus_Awaken",
                nameToLocalize: "辰砂之纺锤"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Falcon_Awaken",
                nameToLocalize: "风鹰剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Troupe_Awaken",
                nameToLocalize: "钟剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Dragonfell_Awaken",
                nameToLocalize: "雪葬的星银"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Widsith_Awaken",
                nameToLocalize: "松籁响起之时"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Zephyrus_Awaken",
                nameToLocalize: "西风秘典"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Theocrat_Awaken",
                nameToLocalize: "宗室秘法录"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Troupe_Awaken",
                nameToLocalize: "绝弦"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Viridescent_Awaken",
                nameToLocalize: "苍翠猎弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Nachtblind_Awaken",
                nameToLocalize: "幽夜华尔兹"
            ),
        ]
    )
    static let borealWolf: WeaponOrTalentMaterial = .init(
        imageString: "weapon.BorealWolf",
        nameToLocalize: "「凛风奔狼」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Catalyst_Dvalin_Awaken",
                nameToLocalize: "天空之卷"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Dvalin_Awaken",
                nameToLocalize: "天空之刃"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Dvalin_Awaken",
                nameToLocalize: "天空之翼"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Widsith_Awaken",
                nameToLocalize: "终末嗟叹之诗"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Troupe_Awaken",
                nameToLocalize: "流浪乐章"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Fossil_Awaken",
                nameToLocalize: "祭礼弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Troupe_Awaken",
                nameToLocalize: "笛剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Fossil_Awaken",
                nameToLocalize: "祭礼大剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Bloodstained_Awaken",
                nameToLocalize: "黑剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Gladiator_Awaken",
                nameToLocalize: "决斗之枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Everfrost_Awaken",
                nameToLocalize: "龙脊长枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Outlaw_Awaken",
                nameToLocalize: "暗巷的酒与诗"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Ludiharpastum_Awaken",
                nameToLocalize: "嘟嘟可故事集"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Psalmus_Awaken",
                nameToLocalize: "降临之剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Dvalin_Awaken",
                nameToLocalize: "天空之傲"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Windvane_Awaken",
                nameToLocalize: "风信之锋"
            ),
        ]
    )
    static let dandelionGladiator: WeaponOrTalentMaterial = .init(
        imageString: "weapon.DandelionGladiator",
        nameToLocalize: "「狮牙斗士」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Fossil_Awaken",
                nameToLocalize: "祭礼剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Magnum_Awaken",
                nameToLocalize: "腐殖之剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Widsith_Awaken",
                nameToLocalize: "苍古自由之誓"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Zephyrus_Awaken",
                nameToLocalize: "西风大剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Theocrat_Awaken",
                nameToLocalize: "宗室大剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Wolfmound_Awaken",
                nameToLocalize: "狼的末路"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Zephyrus_Awaken",
                nameToLocalize: "西风长枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Dvalin_Awaken",
                nameToLocalize: "天空之脊"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Fossil_Awaken",
                nameToLocalize: "祭礼残章"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Everfrost_Awaken",
                nameToLocalize: "忍冬之果"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Fourwinds_Awaken",
                nameToLocalize: "四风原典"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Zephyrus_Awaken",
                nameToLocalize: "西风猎弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Theocrat_Awaken",
                nameToLocalize: "宗室长弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Outlaw_Awaken",
                nameToLocalize: "暗巷猎手"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Exotic_Awaken",
                nameToLocalize: "风花之颂"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Amos_Awaken",
                nameToLocalize: "阿莫斯之弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Fleurfair_Awaken",
                nameToLocalize: "饰铁之花"
            ),
        ]
    )

    // 璃月
    static let guyun: WeaponOrTalentMaterial = .init(
        imageString: "weapon.Guyun",
        nameToLocalize: "「孤云寒林」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Rockkiller_Awaken",
                nameToLocalize: "匣里龙吟"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Blackrock_Awaken",
                nameToLocalize: "黑岩长剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Kunwu_Awaken",
                nameToLocalize: "斫峰之刃"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Exotic_Awaken",
                nameToLocalize: "白影剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Lapis_Awaken",
                nameToLocalize: "千岩古剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Exotic_Awaken",
                nameToLocalize: "流月针"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Morax_Awaken",
                nameToLocalize: "和璞鸢"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Resurrection_Awaken",
                nameToLocalize: "匣里日月"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Blackrock_Awaken",
                nameToLocalize: "黑岩绯玉"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Recluse_Awaken",
                nameToLocalize: "弓藏"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Blackrock_Awaken",
                nameToLocalize: "黑岩战弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Kirin_Awaken",
                nameToLocalize: "若水"
            ),
            .init(imageString: "UI_EquipIcon_Catalyst_Morax_Awaken", nameToLocalize: "碧落之珑"),
        ]
    )
    static let mistVeiled: WeaponOrTalentMaterial = .init(
        imageString: "weapon.MistVeiled",
        nameToLocalize: "「雾海云间」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Proto_Awaken",
                nameToLocalize: "试作斩岩"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Morax_Awaken",
                nameToLocalize: "磐岩结绿"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Perdue_Awaken",
                nameToLocalize: "雨裁"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Blackrock_Awaken",
                nameToLocalize: "黑岩斩刀"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Kunwu_Awaken",
                nameToLocalize: "无工之剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Stardust_Awaken",
                nameToLocalize: "匣里灭辰"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Blackrock_Awaken",
                nameToLocalize: "黑岩刺枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Theocrat_Awaken",
                nameToLocalize: "宗室猎枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Santika_Awaken",
                nameToLocalize: "息灾"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Proto_Awaken",
                nameToLocalize: "试作金珀"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Truelens_Awaken",
                nameToLocalize: "昭心"
            ),
        ]
    )
    static let aerosiderite: WeaponOrTalentMaterial = .init(
        imageString: "weapon.Aerosiderite",
        nameToLocalize: "「漆黑陨铁」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Exotic_Awaken",
                nameToLocalize: "铁蜂刺"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Proto_Awaken",
                nameToLocalize: "试作古华"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Kione_Awaken",
                nameToLocalize: "螭骨剑"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_MillenniaTuna_Awaken",
                nameToLocalize: "衔珠海皇"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Proto_Awaken",
                nameToLocalize: "试作星镰"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Lapis_Awaken",
                nameToLocalize: "千岩长枪"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Homa_Awaken",
                nameToLocalize: "护摩之杖"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Kunwu_Awaken",
                nameToLocalize: "贯虹之槊"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Exotic_Awaken",
                nameToLocalize: "万国诸海图谱"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Kunwu_Awaken",
                nameToLocalize: "尘世之锁"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Exotic_Awaken",
                nameToLocalize: "钢轮弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Fallensun_Awaken",
                nameToLocalize: "落霞"
            ),
        ]
    )

    // 稻妻
    static let distantSea: WeaponOrTalentMaterial = .init(
        imageString: "weapon.DistantSea",
        nameToLocalize: "「远海夷地」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Bakufu_Awaken",
                nameToLocalize: "天目影打刀"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Narukami_Awaken",
                nameToLocalize: "雾切之回光"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Maria_Awaken",
                nameToLocalize: "恶王丸"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Bakufu_Awaken",
                nameToLocalize: "白辰之环"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Jyanome_Awaken",
                nameToLocalize: "证誓之明瞳"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Kaleido_Awaken",
                nameToLocalize: "不灭月华"
            ),
        ]
    )
    static let narukami: WeaponOrTalentMaterial = .init(
        imageString: "weapon.Narukami",
        nameToLocalize: "「鸣神御灵」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Amenoma_Awaken",
                nameToLocalize: "波乱月白经津"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Bakufu_Awaken",
                nameToLocalize: "桂木斩长正"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Itadorimaru_Awaken",
                nameToLocalize: "赤角石溃杵"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Bakufu_Awaken",
                nameToLocalize: "破魔之弓"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Predator_Awaken",
                nameToLocalize: "掠食者"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Maria_Awaken",
                nameToLocalize: "曚云之月"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Narukami_Awaken",
                nameToLocalize: "飞雷之弦振"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Kasabouzu_Awaken",
                nameToLocalize: "东花坊时雨"
            ),
        ]
    )
    static let kijin: WeaponOrTalentMaterial = .init(
        imageString: "weapon.Kijin",
        nameToLocalize: "「今昔剧画」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Youtou_Awaken",
                nameToLocalize: "笼钓瓶一心"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Bakufu_Awaken",
                nameToLocalize: "喜多院十文字"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Mori_Awaken",
                nameToLocalize: "「渔获」"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Maria_Awaken",
                nameToLocalize: "断浪长鳍"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Narukami_Awaken",
                nameToLocalize: "薙草之稻光"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Narukami_Awaken",
                nameToLocalize: "神乐之真意"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Worldbane_Awaken",
                nameToLocalize: "冬极白星"
            ),
        ]
    )

    // 须弥
    static let forestDew: WeaponOrTalentMaterial = .init(
        imageString: "weapon.ForestDew",
        nameToLocalize: "「谧林涓露」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Sword_Arakalari_Awaken",
                nameToLocalize: "原木刀"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Pleroma_Awaken",
                nameToLocalize: "西福斯的月光"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Deshret_Awaken",
                nameToLocalize: "圣显之钥"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Arakalari_Awaken",
                nameToLocalize: "森林王器"
            ),
            .init(
                imageString: "UI_EquipIcon_Sword_Ayus_Awaken",
                nameToLocalize: "裁叶萃光"
            ),
        ]
    )
    static let oasisGarden: WeaponOrTalentMaterial = .init(
        imageString: "weapon.OasisGarden",
        nameToLocalize: "「绿洲花园」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Pole_Arakalari_Awaken",
                nameToLocalize: "贯月矢"
            ),
            .init(
                imageString: "UI_EquipIcon_Pole_Deshret_Awaken",
                nameToLocalize: "赤沙之杖"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Pleroma_Awaken",
                nameToLocalize: "流浪的晚星"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Arakalari_Awaken",
                nameToLocalize: "盈满之实"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Ayus_Awaken",
                nameToLocalize: "千夜浮梦"
            ),
        ]
    )
    static let scorchingMight: WeaponOrTalentMaterial = .init(
        imageString: "weapon.ScorchingMight",
        nameToLocalize: "「烈日威权」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_EquipIcon_Claymore_Pleroma_Awaken",
                nameToLocalize: "玛海菈的水色"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Arakalari_Awaken",
                nameToLocalize: "王下近侍"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Fin_Awaken",
                nameToLocalize: "竭泽"
            ),
            .init(
                imageString: "UI_EquipIcon_Bow_Ayus_Awaken",
                nameToLocalize: "猎人之径"
            ),
            .init(
                imageString: "UI_EquipIcon_Catalyst_Alaya_Awaken",
                nameToLocalize: "图莱杜拉的回忆"
            ),
            .init(
                imageString: "UI_EquipIcon_Claymore_Deshret_Awaken",
                nameToLocalize: "苇海信标"
            ),
        ]
    )

    // 所有材料
    static let allWeaponMaterials: [WeaponOrTalentMaterial] = [
        .decarabian, .borealWolf, .dandelionGladiator, .guyun, .mistVeiled,
        .aerosiderite, .distantSea, .narukami, .kijin, .forestDew,
        .oasisGarden, .scorchingMight,
    ]
    static func allWeaponMaterialsOf(weekday: MaterialWeekday)
        -> [WeaponOrTalentMaterial] {
        allWeaponMaterials.filter { material in
            (material.weekday == weekday) || (weekday == .sunday)
        }
    }

    // MARK: - Talent Material choices

    // 蒙德
    static let freedom: WeaponOrTalentMaterial = .init(
        imageString: "talent.Freedom",
        nameToLocalize: "「自由」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Barbara_Card",
                nameToLocalize: "芭芭拉"
            ),
            .init(
                imageString: "UI_AvatarIcon_Ambor_Card",
                nameToLocalize: "安柏"
            ),
            .init(
                imageString: "UI_AvatarIcon_Klee_Card",
                nameToLocalize: "可莉"
            ),
            .init(
                imageString: "UI_AvatarIcon_Tartaglia_Card",
                nameToLocalize: "达达利亚"
            ),
            .init(
                imageString: "UI_AvatarIcon_Diona_Card",
                nameToLocalize: "迪奥娜"
            ),
            .init(
                imageString: "UI_AvatarIcon_Sucrose_Card",
                nameToLocalize: "砂糖"
            ),
            .init(
                imageString: "UI_AvatarIcon_Aloy_Card",
                nameToLocalize: "埃洛伊"
            ),
        ]
    )
    static let resistance: WeaponOrTalentMaterial = .init(
        imageString: "talent.Resistance",
        nameToLocalize: "「抗争」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Mona_Card",
                nameToLocalize: "莫娜"
            ),
            .init(
                imageString: "UI_AvatarIcon_Qin_Card",
                nameToLocalize: "琴"
            ),
            .init(
                imageString: "UI_AvatarIcon_Eula_Card",
                nameToLocalize: "优菈"
            ),
            .init(
                imageString: "UI_AvatarIcon_Diluc_Card",
                nameToLocalize: "迪卢克"
            ),
            .init(
                imageString: "UI_AvatarIcon_Razor_Card",
                nameToLocalize: "雷泽"
            ),
            .init(
                imageString: "UI_AvatarIcon_Noel_Card",
                nameToLocalize: "诺艾尔"
            ),
            .init(
                imageString: "UI_AvatarIcon_Bennett_Card",
                nameToLocalize: "班尼特"
            ),
        ]
    )
    static let ballad: WeaponOrTalentMaterial = .init(
        imageString: "talent.Ballad",
        nameToLocalize: "「诗文」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Lisa_Card",
                nameToLocalize: "丽莎"
            ),
            .init(
                imageString: "UI_AvatarIcon_Fischl_Card",
                nameToLocalize: "菲谢尔"
            ),
            .init(
                imageString: "UI_AvatarIcon_Kaeya_Card",
                nameToLocalize: "凯亚"
            ),
            .init(
                imageString: "UI_AvatarIcon_Venti_Card",
                nameToLocalize: "温迪"
            ),
            .init(
                imageString: "UI_AvatarIcon_Albedo_Card",
                nameToLocalize: "阿贝多"
            ),
            .init(
                imageString: "UI_AvatarIcon_Rosaria_Card",
                nameToLocalize: "罗莎莉亚"
            ),
            .init(
                imageString: "UI_AvatarIcon_Mika_Card",
                nameToLocalize: "米卡"
            ),
        ]
    )

    // 璃月
    static let prosperity: WeaponOrTalentMaterial = .init(
        imageString: "talent.Prosperity",
        nameToLocalize: "「繁荣」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Xiao_Card",
                nameToLocalize: "魈"
            ),
            .init(
                imageString: "UI_AvatarIcon_Ningguang_Card",
                nameToLocalize: "凝光"
            ),
            .init(
                imageString: "UI_AvatarIcon_Qiqi_Card",
                nameToLocalize: "七七"
            ),
            .init(
                imageString: "UI_AvatarIcon_Keqing_Card",
                nameToLocalize: "刻晴"
            ),
            .init(
                imageString: "UI_AvatarIcon_Yelan_Card",
                nameToLocalize: "夜兰"
            ),
            .init(
                imageString: "UI_AvatarIcon_Shenhe_Card",
                nameToLocalize: "申鹤"
            ),
        ]
    )
    static let diligence: WeaponOrTalentMaterial = .init(
        imageString: "talent.Diligence",
        nameToLocalize: "「勤劳」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Xiangling_Card",
                nameToLocalize: "香菱"
            ),
            .init(
                imageString: "UI_AvatarIcon_Chongyun_Card",
                nameToLocalize: "重云"
            ),
            .init(
                imageString: "UI_AvatarIcon_Ganyu_Card",
                nameToLocalize: "甘雨"
            ),
            .init(
                imageString: "UI_AvatarIcon_Hutao_Card",
                nameToLocalize: "胡桃"
            ),
            .init(
                imageString: "UI_AvatarIcon_Kazuha_Card",
                nameToLocalize: "枫原万叶"
            ),
            .init(
                imageString: "UI_AvatarIcon_Yunjin_Card",
                nameToLocalize: "云堇"
            ),
            .init(
                imageString: "UI_AvatarIcon_Yaoyao_Card",
                nameToLocalize: "瑶瑶"
            ),
        ]
    )
    static let gold: WeaponOrTalentMaterial = .init(
        imageString: "talent.Gold",
        nameToLocalize: "「黄金」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Beidou_Card",
                nameToLocalize: "北斗"
            ),
            .init(
                imageString: "UI_AvatarIcon_Xingqiu_Card",
                nameToLocalize: "行秋"
            ),
            .init(
                imageString: "UI_AvatarIcon_Zhongli_Card",
                nameToLocalize: "钟离"
            ),
            .init(
                imageString: "UI_AvatarIcon_Xinyan_Card",
                nameToLocalize: "辛焱"
            ),
            .init(
                imageString: "UI_AvatarIcon_Feiyan_Card",
                nameToLocalize: "烟绯"
            ),
            .init(imageString: "UI_AvatarIcon_Baizhuer_Card", nameToLocalize: "白术"),
        ]
    )

    // 稻妻
    static let transience: WeaponOrTalentMaterial = .init(
        imageString: "talent.Transience",
        nameToLocalize: "「浮世」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Yoimiya_Card",
                nameToLocalize: "宵宫"
            ),
            .init(
                imageString: "UI_AvatarIcon_Tohma_Card",
                nameToLocalize: "托马"
            ),
            .init(
                imageString: "UI_AvatarIcon_Kokomi_Card",
                nameToLocalize: "珊瑚宫心海"
            ),
            .init(
                imageString: "UI_AvatarIcon_Heizo_Card",
                nameToLocalize: "鹿野院平藏"
            ),
        ]
    )
    static let elegance: WeaponOrTalentMaterial = .init(
        imageString: "talent.Elegance",
        nameToLocalize: "「风雅」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Sara_Card",
                nameToLocalize: "九条裟罗"
            ),
            .init(
                imageString: "UI_AvatarIcon_Ayaka_Card",
                nameToLocalize: "神里绫华"
            ),
            .init(
                imageString: "UI_AvatarIcon_Itto_Card",
                nameToLocalize: "荒泷一斗"
            ),
            .init(
                imageString: "UI_AvatarIcon_Shinobu_Card",
                nameToLocalize: "久岐忍"
            ),
            .init(
                imageString: "UI_AvatarIcon_Ayato_Card",
                nameToLocalize: "神里绫人"
            ),
        ]
    )
    static let light: WeaponOrTalentMaterial = .init(
        imageString: "talent.Light",
        nameToLocalize: "「天光」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Shougun_Card",
                nameToLocalize: "雷电将军"
            ),
            .init(
                imageString: "UI_AvatarIcon_Sayu_Card",
                nameToLocalize: "早柚"
            ),
            .init(
                imageString: "UI_AvatarIcon_Gorou_Card",
                nameToLocalize: "五郎"
            ),
            .init(
                imageString: "UI_AvatarIcon_Yae_Card",
                nameToLocalize: "八重神子"
            ),
        ]
    )

    // 须弥
    static let admonition: WeaponOrTalentMaterial = .init(
        imageString: "talent.Admonition",
        nameToLocalize: "「诤言」",
        weekday: .mondayAndThursday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Tighnari_Card",
                nameToLocalize: "提纳里"
            ),
            .init(
                imageString: "UI_AvatarIcon_Candace_Card",
                nameToLocalize: "坎蒂丝"
            ),
            .init(
                imageString: "UI_AvatarIcon_Cyno_Card",
                nameToLocalize: "赛诺"
            ),
            .init(
                imageString: "UI_AvatarIcon_Faruzan_Card",
                nameToLocalize: "珐露珊"
            ),
        ]
    )
    static let ingenuity: WeaponOrTalentMaterial = .init(
        imageString: "talent.Ingenuity",
        nameToLocalize: "「巧思」",
        weekday: .tuesdayAndFriday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Dori_Card",
                nameToLocalize: "多莉"
            ),
            .init(
                imageString: "UI_AvatarIcon_Nahida_Card",
                nameToLocalize: "纳西妲"
            ),
            .init(
                imageString: "UI_AvatarIcon_Layla_Card",
                nameToLocalize: "莱依拉"
            ),
            .init(
                imageString: "UI_AvatarIcon_Alhatham_Card",
                nameToLocalize: "艾尔海森"
            ),
            .init(imageString: "UI_AvatarIcon_Kaveh_Card", nameToLocalize: "卡维"),
        ]
    )
    static let praxis: WeaponOrTalentMaterial = .init(
        imageString: "talent.Praxis",
        nameToLocalize: "「笃行」",
        weekday: .wednesdayAndSaturday,
        relatedItem: [
            .init(
                imageString: "UI_AvatarIcon_Collei_Card",
                nameToLocalize: "柯莱"
            ),
            .init(
                imageString: "UI_AvatarIcon_Nilou_Card",
                nameToLocalize: "妮露"
            ),
            .init(
                imageString: "UI_AvatarIcon_Wanderer_Card",
                nameToLocalize: "流浪者"
            ),
            .init(
                imageString: "UI_AvatarIcon_Dehya_Card",
                nameToLocalize: "迪希雅"
            ),
        ]
    )

    // 所有天赋材料
    static let allTalentMaterials: [WeaponOrTalentMaterial] = [
        .freedom, .resistance, .ballad, .prosperity, .diligence, .gold,
        .transience, .elegance, .light, .admonition, .ingenuity, .praxis,
    ]
    static func allTalentMaterialsOf(weekday: MaterialWeekday)
        -> [WeaponOrTalentMaterial] {
        allTalentMaterials.filter { material in
            (material.weekday == weekday) || (weekday == .sunday)
        }
    }
}
