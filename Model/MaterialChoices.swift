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
    static let decarabian: WeaponOrTalentMaterial = .init(imageString: "weapon.Decarabian", localizedName: "「高塔孤王」", weekday: .mondayAndThursday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_EquipIcon_Sword_Zephyrus_Awaken", localizedName: "西风剑"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Theocrat_Awaken", localizedName: "宗室长剑"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Outlaw_Awaken", localizedName: "暗巷闪光"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Opus_Awaken", localizedName: "辰砂之纺锤"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Falcon_Awaken", localizedName: "风鹰剑"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Troupe_Awaken", localizedName: "钟剑"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Dragonfell_Awaken", localizedName: "雪葬的星银"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Widsith_Awaken", localizedName: "松籁响起之时"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Zephyrus_Awaken", localizedName: "西风秘典"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Theocrat_Awaken", localizedName: "宗室秘法录"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Troupe_Awaken", localizedName: "绝弦"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Viridescent_Awaken", localizedName: "苍翠猎弓"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Nachtblind_Awaken", localizedName: "幽夜华尔兹"),
                                                          ]
    )
    static let borealWolf: WeaponOrTalentMaterial = .init(imageString: "weapon.BorealWolf", localizedName: "「凛风奔狼」", weekday: .tuesdayAndFriday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Dvalin_Awaken", localizedName: "天空之卷"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Dvalin_Awaken", localizedName: "天空之刃"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Dvalin_Awaken", localizedName: "天空之翼"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Widsith_Awaken", localizedName: "终末嗟叹之诗"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Troupe_Awaken", localizedName: "流浪乐章"),
                                                            .init(imageString: "UI_EquipIcon_Bow_Fossil_Awaken", localizedName: "祭礼弓"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Troupe_Awaken", localizedName: "笛剑"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Fossil_Awaken", localizedName: "祭礼大剑"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Bloodstained_Awaken", localizedName: "黑剑"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Gladiator_Awaken", localizedName: "决斗之枪"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Everfrost_Awaken", localizedName: "龙脊长枪"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Outlaw_Awaken", localizedName: "暗巷的酒与诗"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Ludiharpastum_Awaken", localizedName: "嘟嘟可故事集"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Psalmus_Awaken", localizedName: "降临之剑"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Dvalin_Awaken", localizedName: "天空之傲"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Windvane", localizedName: "风信之锋")
                                                          ]
    )
    static let dandelionGladiator: WeaponOrTalentMaterial = .init(imageString: "weapon.DandelionGladiator", localizedName: "「狮牙斗士」", weekday: .wednesdayAndSaturday,
                                                                  relatedItem: [
                                                                    .init(imageString: "UI_EquipIcon_Sword_Fossil_Awaken", localizedName: "祭礼剑"),
                                                                    .init(imageString: "UI_EquipIcon_Sword_Magnum_Awaken", localizedName: "腐殖之剑"),
                                                                    .init(imageString: "UI_EquipIcon_Sword_Widsith_Awaken", localizedName: "苍古自由之誓"),
                                                                    .init(imageString: "UI_EquipIcon_Claymore_Zephyrus_Awaken", localizedName: "西风大剑"),
                                                                    .init(imageString: "UI_EquipIcon_Claymore_Theocrat_Awaken", localizedName: "宗室大剑"),
                                                                    .init(imageString: "UI_EquipIcon_Claymore_Wolfmound_Awaken", localizedName: "狼的末路"),
                                                                    .init(imageString: "UI_EquipIcon_Pole_Zephyrus_Awaken", localizedName: "西风长枪"),
                                                                    .init(imageString: "UI_EquipIcon_Pole_Dvalin_Awaken", localizedName: "天空之脊"),
                                                                    .init(imageString: "UI_EquipIcon_Catalyst_Fossil_Awaken", localizedName: "祭礼残章"),
                                                                    .init(imageString: "UI_EquipIcon_Catalyst_Everfrost_Awaken", localizedName: "忍冬之果"),
                                                                    .init(imageString: "UI_EquipIcon_Catalyst_Fourwinds_Awaken", localizedName: "四风原典"),
                                                                    .init(imageString: "UI_EquipIcon_Bow_Zephyrus_Awaken", localizedName: "西风猎弓"),
                                                                    .init(imageString: "UI_EquipIcon_Bow_Theocrat_Awaken", localizedName: "宗室长弓"),
                                                                    .init(imageString: "UI_EquipIcon_Bow_Outlaw_Awaken", localizedName: "暗巷猎手"),
                                                                    .init(imageString: "UI_EquipIcon_Bow_Exotic_Awaken", localizedName: "风花之颂"),
                                                                    .init(imageString: "UI_EquipIcon_Bow_Amos_Awaken", localizedName: "阿莫斯之弓"),
                                                                  ]
    )

    // 璃月
    static let guyun: WeaponOrTalentMaterial = .init(imageString: "weapon.Guyun", localizedName: "「孤云寒林」", weekday: .mondayAndThursday,
                                                     relatedItem: [
                                                       .init(imageString: "UI_EquipIcon_Sword_Rockkiller_Awaken", localizedName: "匣里龙吟"),
                                                       .init(imageString: "UI_EquipIcon_Sword_Blackrock_Awaken", localizedName: "黑岩长剑"),
                                                       .init(imageString: "UI_EquipIcon_Sword_Kunwu_Awaken", localizedName: "斫峰之刃"),
                                                       .init(imageString: "UI_EquipIcon_Sword_Whiteblind", localizedName: "白影剑"),
                                                       .init(imageString: "UI_EquipIcon_Claymore_Lapis_Awaken", localizedName: "千岩古剑"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Exotic_Awaken", localizedName: "流月针"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Morax_Awaken", localizedName: "和璞鸢"),
                                                       .init(imageString: "UI_EquipIcon_Catalyst_Resurrection_Awaken", localizedName: "匣里日月"),
                                                       .init(imageString: "UI_EquipIcon_Catalyst_Blackrock_Awaken", localizedName: "黑岩绯玉"),
                                                       .init(imageString: "UI_EquipIcon_Bow_Recluse_Awaken", localizedName: "弓藏"),
                                                       .init(imageString: "UI_EquipIcon_Bow_Blackrock_Awaken", localizedName: "黑岩战弓"),
                                                       .init(imageString: "UI_EquipIcon_Bow_Kirin_Awaken", localizedName: "若水"),
                                                     ]
    )
    static let mistVeiled: WeaponOrTalentMaterial = .init(imageString: "weapon.MistVeiled", localizedName: "「雾海云间」", weekday: .tuesdayAndFriday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_EquipIcon_Sword_Proto_Awaken", localizedName: "试作斩岩"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Morax_Awaken", localizedName: "磐岩结绿"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Perdue_Awaken", localizedName: "雨裁"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Blackrock_Awaken", localizedName: "黑岩斩刀"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Kunwu_Awaken", localizedName: "无工之剑"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Stardust_Awaken", localizedName: "匣里灭辰"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Blackrock_Awaken", localizedName: "黑岩刺枪"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Theocrat_Awaken", localizedName: "宗室猎枪"),
                                                            .init(imageString: "UI_EquipIcon_Pole_Santika_Awaken", localizedName: "息灾"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Proto_Awaken", localizedName: "试作金珀"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Truelens_Awaken", localizedName: "昭心"),
                                                          ]
    )
    static let aerosiderite: WeaponOrTalentMaterial = .init(imageString: "weapon.Aerosiderite", localizedName: "「漆黑陨铁」", weekday: .wednesdayAndSaturday,
                                                            relatedItem: [
                                                              .init(imageString: "UI_EquipIcon_Sword_Exotic_Awaken", localizedName: "铁蜂刺"),
                                                              .init(imageString: "UI_EquipIcon_Claymore_Proto_Awaken", localizedName: "试作古华"),
                                                              .init(imageString: "UI_EquipIcon_Claymore_Kione_Awaken", localizedName: "螭骨剑"),
                                                              .init(imageString: "UI_EquipIcon_Claymore_MillenniaTuna_Awaken", localizedName: "衔珠海皇"),
                                                              .init(imageString: "UI_EquipIcon_Pole_Proto_Awaken", localizedName: "试作星镰"),
                                                              .init(imageString: "UI_EquipIcon_Pole_Lapis_Awaken", localizedName: "千岩长枪"),
                                                              .init(imageString: "UI_EquipIcon_Pole_Homa_Awaken", localizedName: "护摩之杖"),
                                                              .init(imageString: "UI_EquipIcon_Pole_Kunwu_Awaken", localizedName: "贯虹之槊"),
                                                              .init(imageString: "UI_EquipIcon_Catalyst_Exotic_Awaken", localizedName: "万国诸海图谱"),
                                                              .init(imageString: "UI_EquipIcon_Catalyst_Kunwu_Awaken", localizedName: "尘世之锁"),
                                                              .init(imageString: "UI_EquipIcon_Bow_Exotic_Awaken", localizedName: "钢轮弓"),
                                                              .init(imageString: "UI_EquipIcon_Bow_Fallensun_Awaken", localizedName: "落霞"),
                                                            ]
    )

    // 稻妻
    static let distantSea: WeaponOrTalentMaterial = .init(imageString: "weapon.DistantSea", localizedName: "「远海夷地」", weekday: .mondayAndThursday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_EquipIcon_Sword_Bakufu_Awaken", localizedName: "天目影打刀"),
                                                            .init(imageString: "UI_EquipIcon_Sword_Narukami_Awaken", localizedName: "雾切之回光"),
                                                            .init(imageString: "UI_EquipIcon_Claymore_Maria_Awaken", localizedName: "恶王丸"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Bakufu_Awaken", localizedName: "白辰之环"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Jyanome_Awaken", localizedName: "证誓之明瞳"),
                                                            .init(imageString: "UI_EquipIcon_Catalyst_Kaleido_Awaken", localizedName: "不灭月华"),
                                                          ]
    )
    static let narukami: WeaponOrTalentMaterial = .init(imageString: "weapon.Narukami", localizedName: "「鸣神御灵」", weekday: .tuesdayAndFriday,
                                                        relatedItem: [
                                                          .init(imageString: "UI_EquipIcon_Sword_Amenoma_Awaken", localizedName: "波乱月白经津"),
                                                          .init(imageString: "UI_EquipIcon_Claymore_Bakufu_Awaken", localizedName: "桂木斩长正"),
                                                          .init(imageString: "UI_EquipIcon_Claymore_Itadorimaru_Awaken", localizedName: "赤角石溃杵"),
                                                          .init(imageString: "UI_EquipIcon_Bow_Bakufu_Awaken", localizedName: "破魔之弓"),
                                                          .init(imageString: "UI_EquipIcon_Bow_Predator_Awaken", localizedName: "掠食者"),
                                                          .init(imageString: "UI_EquipIcon_Bow_Maria_Awaken", localizedName: "曚云之月"),
                                                          .init(imageString: "UI_EquipIcon_Bow_Narukami_Awaken", localizedName: "飞雷之弦振"),
                                                          .init(imageString: "UI_EquipIcon_Sword_Kasabouzu_Awaken", localizedName: "东花坊时雨")
                                                        ]
    )
    static let kijin: WeaponOrTalentMaterial = .init(imageString: "weapon.Kijin", localizedName: "「今昔剧画」", weekday: .wednesdayAndSaturday,
                                                     relatedItem: [
                                                       .init(imageString: "UI_EquipIcon_Sword_Youtou_Awaken", localizedName: "笼钓瓶一心"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Bakufu_Awaken", localizedName: "喜多院十文字"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Mori_Awaken", localizedName: "「渔获」"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Maria_Awaken", localizedName: "断浪长鳍"),
                                                       .init(imageString: "UI_EquipIcon_Pole_Narukami_Awaken", localizedName: "薙草之稻光"),
                                                       .init(imageString: "UI_EquipIcon_Catalyst_Narukami_Awaken", localizedName: "神乐之真意"),
                                                       .init(imageString: "UI_EquipIcon_Bow_Worldbane_Awaken", localizedName: "冬极白星"),
                                                     ]
    )

    // 须弥
    static let forestDew: WeaponOrTalentMaterial = .init(imageString: "weapon.ForestDew", localizedName: "「谧林涓露」", weekday: .mondayAndThursday,
                                                         relatedItem: [
                                                           .init(imageString: "UI_EquipIcon_Sword_Arakalari_Awaken", localizedName: "原木刀"),
                                                           .init(imageString: "UI_EquipIcon_Sword_Pleroma_Awaken", localizedName: "西福斯的月光"),
                                                           .init(imageString: "UI_EquipIcon_Sword_Deshret_Awaken", localizedName: "圣显之钥"),
                                                           .init(imageString: "UI_EquipIcon_Claymore_Arakalari_Awaken", localizedName: "森林王器"),
                                                         ]
    )
    static let oasisGarden: WeaponOrTalentMaterial = .init(imageString: "weapon.OasisGarden", localizedName: "「绿洲花园」", weekday: .tuesdayAndFriday,
                                                           relatedItem: [
                                                             .init(imageString: "UI_EquipIcon_Pole_Arakalari_Awaken", localizedName: "贯月矢"),
                                                             .init(imageString: "UI_EquipIcon_Pole_Deshret_Awaken", localizedName: "赤沙之杖"),
                                                             .init(imageString: "UI_EquipIcon_Catalyst_Pleroma_Awaken", localizedName: "流浪的晚星"),
                                                             .init(imageString: "UI_EquipIcon_Catalyst_Arakalari_Awaken", localizedName: "盈满之实"),
                                                             .init(imageString: "UI_EquipIcon_Catalyst_Ayus_Awaken", localizedName: "千夜浮梦")
                                                           ]
    )
    static let scorchingMight: WeaponOrTalentMaterial = .init(imageString: "weapon.ScorchingMight", localizedName: "「烈日威权」", weekday: .wednesdayAndSaturday,
                                                              relatedItem: [
                                                                .init(imageString: "UI_EquipIcon_Claymore_Pleroma_Awaken", localizedName: "玛海菈的水色"),
                                                                .init(imageString: "UI_EquipIcon_Bow_Arakalari_Awaken", localizedName: "王下近侍"),
                                                                .init(imageString: "UI_EquipIcon_Bow_Fin_Awaken", localizedName: "竭泽"),
                                                                .init(imageString: "UI_EquipIcon_Bow_Ayus_Awaken", localizedName: "猎人之径"),
                                                                .init(imageString: "UI_EquipIcon_Catalyst_Alaya_Awaken", localizedName: "图莱杜拉的回忆")
                                                              ]
    )

    // 所有材料
    static let allWeaponMaterials: [WeaponOrTalentMaterial] = [
        .decarabian, .borealWolf, .dandelionGladiator, .guyun, .mistVeiled, .aerosiderite, .distantSea, .narukami, .kijin, .forestDew, .oasisGarden, .scorchingMight
    ]
    static func allWeaponMaterialsOf(weekday: MaterialWeekday) -> [WeaponOrTalentMaterial] {
        allWeaponMaterials.filter { material in
            (material.weekday == weekday) || (weekday == .sunday)
        }
    }

    // MARK: - Talent Material choices
    // 蒙德
    static let freedom: WeaponOrTalentMaterial = .init(imageString: "talent.Freedom", localizedName: "「自由」", weekday: .mondayAndThursday,
                                                       relatedItem: [
                                                        .init(imageString: "UI_AvatarIcon_Barbara_Card", localizedName: "芭芭拉"),
                                                        .init(imageString: "UI_AvatarIcon_Ambor_Card", localizedName: "安柏"),
                                                        .init(imageString: "UI_AvatarIcon_Klee_Card", localizedName: "可莉"),
                                                        .init(imageString: "UI_AvatarIcon_Tartaglia_Card", localizedName: "达达利亚"),
                                                        .init(imageString: "UI_AvatarIcon_Diona_Card", localizedName: "迪奥娜"),
                                                        .init(imageString: "UI_AvatarIcon_Sucrose_Card", localizedName: "砂糖"),
                                                        .init(imageString: "UI_AvatarIcon_Aloy_Card", localizedName: "埃洛伊"),
                                                       ]
    )
    static let resistance: WeaponOrTalentMaterial = .init(imageString: "talent.Resistance", localizedName: "「抗争」", weekday: .tuesdayAndFriday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_AvatarIcon_Mona_Card", localizedName: "莫娜"),
                                                            .init(imageString: "UI_AvatarIcon_Qin_Card", localizedName: "琴"),
                                                            .init(imageString: "UI_AvatarIcon_Eula_Card", localizedName: "优菈"),
                                                            .init(imageString: "UI_AvatarIcon_Diluc_Card", localizedName: "迪卢克"),
                                                            .init(imageString: "UI_AvatarIcon_Razor_Card", localizedName: "雷泽"),
                                                            .init(imageString: "UI_AvatarIcon_Noel_Card", localizedName: "诺艾尔"),
                                                            .init(imageString: "UI_AvatarIcon_Bennett_Card", localizedName: "班尼特"),
                                                          ])
    static let ballad: WeaponOrTalentMaterial = .init(imageString: "talent.Ballad", localizedName: "「诗文」", weekday: .wednesdayAndSaturday,
                                                      relatedItem: [
                                                       .init(imageString: "UI_AvatarIcon_Lisa_Card", localizedName: "丽莎"),
                                                       .init(imageString: "UI_AvatarIcon_Fischl_Card", localizedName: "菲谢尔"),
                                                       .init(imageString: "UI_AvatarIcon_Kaeya_Card", localizedName: "凯亚"),
                                                       .init(imageString: "UI_AvatarIcon_Venti_Card", localizedName: "温迪"),
                                                       .init(imageString: "UI_AvatarIcon_Albedo_Card", localizedName: "阿贝多"),
                                                       .init(imageString: "UI_AvatarIcon_Rosaria_Card", localizedName: "罗莎莉亚"),
                                                      ])

    // 璃月
    static let prosperity: WeaponOrTalentMaterial = .init(imageString: "talent.Prosperity", localizedName: "「繁荣」", weekday: .mondayAndThursday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_AvatarIcon_Xiao_Card", localizedName: "魈"),
                                                            .init(imageString: "UI_AvatarIcon_Ningguang_Card", localizedName: "凝光"),
                                                            .init(imageString: "UI_AvatarIcon_Qiqi_Card", localizedName: "七七"),
                                                            .init(imageString: "UI_AvatarIcon_Keqing_Card", localizedName: "刻晴"),
                                                            .init(imageString: "UI_AvatarIcon_Yelan_Card", localizedName: "夜兰"),
                                                            .init(imageString: "UI_AvatarIcon_Shenhe_Card", localizedName: "申鹤"),
                                                          ]
    )
    static let diligence: WeaponOrTalentMaterial = .init(imageString: "talent.Diligence", localizedName: "「勤劳」", weekday: .tuesdayAndFriday,
                                                         relatedItem: [
                                                            .init(imageString: "UI_AvatarIcon_Xiangling_Card", localizedName: "香菱"),
                                                            .init(imageString: "UI_AvatarIcon_Chongyun_Card", localizedName: "重云"),
                                                            .init(imageString: "UI_AvatarIcon_Ganyu_Card", localizedName: "甘雨"),
                                                            .init(imageString: "UI_AvatarIcon_Hutao_Card", localizedName: "胡桃"),
                                                            .init(imageString: "UI_AvatarIcon_Kazuha_Card", localizedName: "枫原万叶"),
                                                            .init(imageString: "UI_AvatarIcon_Yunjin_Card", localizedName: "云堇"),
                                                         ]
    )
    static let gold: WeaponOrTalentMaterial = .init(imageString: "talent.Gold", localizedName: "「黄金」", weekday: .wednesdayAndSaturday,
                                                    relatedItem: [
                                                        .init(imageString: "UI_AvatarIcon_Beidou_Card", localizedName: "北斗"),
                                                        .init(imageString: "UI_AvatarIcon_Xingqiu_Card", localizedName: "行秋"),
                                                        .init(imageString: "UI_AvatarIcon_Zhongli_Card", localizedName: "钟离"),
                                                        .init(imageString: "UI_AvatarIcon_Xinyan_Card", localizedName: "辛焱"),
                                                        .init(imageString: "UI_AvatarIcon_Feiyan_Card", localizedName: "烟绯"),
                                                    ]
    )

    // 稻妻
    static let transience: WeaponOrTalentMaterial = .init(imageString: "talent.Transience", localizedName: "「浮世」", weekday: .mondayAndThursday,
                                                          relatedItem: [
                                                              .init(imageString: "UI_AvatarIcon_Yoimiya_Card", localizedName: "宵宫"),
                                                              .init(imageString: "UI_AvatarIcon_Tohma_Card", localizedName: "托马"),
                                                              .init(imageString: "UI_AvatarIcon_Kokomi_Card", localizedName: "珊瑚宫心海"),
                                                              .init(imageString: "UI_AvatarIcon_Heizo_Card", localizedName: "鹿野院平藏"),
                                                          ]
    )
    static let elegance: WeaponOrTalentMaterial = .init(imageString: "talent.Elegance", localizedName: "「风雅」", weekday: .tuesdayAndFriday,
                                                        relatedItem: [
                                                            .init(imageString: "UI_AvatarIcon_Sara_Card", localizedName: "九条裟罗"),
                                                            .init(imageString: "UI_AvatarIcon_Ayaka_Card", localizedName: "神里绫华"),
                                                            .init(imageString: "UI_AvatarIcon_Itto_Card", localizedName: "荒泷一斗"),
                                                            .init(imageString: "UI_AvatarIcon_Shinobu_Card", localizedName: "久岐忍"),
                                                            .init(imageString: "UI_AvatarIcon_Ayato_Card", localizedName: "神里绫人"),
                                                        ]
    )
    static let light: WeaponOrTalentMaterial = .init(imageString: "talent.Light", localizedName: "「天光」", weekday: .wednesdayAndSaturday,
                                                     relatedItem: [
                                                         .init(imageString: "UI_AvatarIcon_Shougun_Card", localizedName: "雷电将军"),
                                                         .init(imageString: "UI_AvatarIcon_Sayu_Card", localizedName: "早柚"),
                                                         .init(imageString: "UI_AvatarIcon_Gorou_Card", localizedName: "五郎"),
                                                         .init(imageString: "UI_AvatarIcon_Yae_Card", localizedName: "八重神子"),
                                                     ]
    )

    // 须弥
    static let admonition: WeaponOrTalentMaterial = .init(imageString: "talent.Admonition", localizedName: "「诤言」", weekday: .mondayAndThursday,
                                                          relatedItem: [
                                                            .init(imageString: "UI_AvatarIcon_Tighnari_Card", localizedName: "提纳里"),
                                                            .init(imageString: "UI_AvatarIcon_Candace_Card", localizedName: "坎蒂丝"),
                                                            .init(imageString: "UI_AvatarIcon_Cyno_Card", localizedName: "赛诺"),
                                                            .init(imageString: "UI_AvatarIcon_Faruzan_Card", localizedName: "珐露珊")
                                                          ]
    )
    static let ingenuity: WeaponOrTalentMaterial = .init(imageString: "talent.Ingenuity", localizedName: "「巧思」", weekday: .tuesdayAndFriday,
                                                         relatedItem: [
                                                           .init(imageString: "UI_AvatarIcon_Dori_Card", localizedName: "多莉"),
                                                           .init(imageString: "UI_AvatarIcon_Nahida_Card", localizedName: "纳西妲"),
                                                           .init(imageString: "UI_AvatarIcon_Layla_Card", localizedName: "莱依拉")
                                                         ]
    )
    static let praxis: WeaponOrTalentMaterial = .init(imageString: "talent.Praxis", localizedName: "「笃行」", weekday: .wednesdayAndSaturday,
                                                      relatedItem: [
                                                        .init(imageString: "UI_AvatarIcon_Collei_Card", localizedName: "柯莱"),
                                                        .init(imageString: "UI_AvatarIcon_Nilou_Card", localizedName: "妮露"),
                                                        .init(imageString: "UI_AvatarIcon_Wanderer_Card", localizedName: "流浪者")
                                                      ]
    )

    // 所有天赋材料
    static let allTalentMaterials: [WeaponOrTalentMaterial] = [
        .freedom, .resistance, .ballad, .prosperity, .diligence, .gold, .transience, .elegance, .light, .admonition, .ingenuity, .praxis
    ]
    static func allTalentMaterialsOf(weekday: MaterialWeekday) -> [WeaponOrTalentMaterial] {
        allTalentMaterials.filter { material in
            (material.weekday == weekday) || (weekday == .sunday)
        }
    }
}
