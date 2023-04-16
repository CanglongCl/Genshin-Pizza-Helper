//
//  PropertyDictionary.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/25.
//

import Foundation

class PropertyDictionary {
    static var dict: [String: String] = [
        "FIGHT_PROP_BASE_ATTACK": "基础攻击力",
        "FIGHT_PROP_MAX_HP": "生命值上限",
        "FIGHT_PROP_ATTACK": "攻击力",
        "FIGHT_PROP_DEFENSE": "防御力",
        "FIGHT_PROP_ELEMENT_MASTERY": "元素精通​", // 此处元素精通后添加了一个零宽字符，用于英文缩写
        "FIGHT_PROP_CRITICAL": "暴击率%%",
        "FIGHT_PROP_CRITICAL_HURT": "暴击伤害%%",
        "FIGHT_PROP_HEAL_ADD": "治疗加成%%",
        "FIGHT_PROP_HEALED_ADD": "受治疗加成",
        "FIGHT_PROP_CHARGE_EFFICIENCY": "元素充能%%",
        "FIGHT_PROP_SHIELD_COST_MINUS_RATIO": "护盾强效",
        "FIGHT_PROP_FIRE_ADD_HURT": "火伤加成%%",
        "FIGHT_PROP_WATER_ADD_HURT": "水伤加成%%",
        "FIGHT_PROP_GRASS_ADD_HURT": "草伤加成%%",
        "FIGHT_PROP_ELEC_ADD_HURT": "雷伤加成%%",
        "FIGHT_PROP_WIND_ADD_HURT": "风伤加成%%",
        "FIGHT_PROP_ICE_ADD_HURT": "冰伤加成%%",
        "FIGHT_PROP_ROCK_ADD_HURT": "岩伤加成%%",
        "FIGHT_PROP_PHYSICAL_ADD_HURT": "物伤加成%%",
        "FIGHT_PROP_HP": "生命值",
        "FIGHT_PROP_ATTACK_PERCENT": "攻击力%%",
        "FIGHT_PROP_HP_PERCENT": "生命值%%",
        "FIGHT_PROP_DEFENSE_PERCENT": "防御力%%",
    ]

    static func getLocalizedName(_ key: String) -> String {
        dict[key]?.localized ?? "Unknown"
    }
}
