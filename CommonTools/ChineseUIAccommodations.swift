//
//  ChineseUIAccommodations.swift
//  GenshinPizzaHelper
//
//  Created by ShikiSuen on 2023/3/26.
//  检测当前介面语言是否是简体中文或繁体中文，以及在这种情况下的一些特殊操作。

import Foundation
import HBPizzaHelperAPI

extension Locale {
    public static var isUILanguagePanChinese: Bool {
        guard let firstLocale = Bundle.main.preferredLocalizations.first
        else { return false }
        return firstLocale.prefix(3).description == "zh-"
    }

    public static var isUILanguageJapanese: Bool {
        guard let firstLocale = Bundle.main.preferredLocalizations.first
        else { return false }
        return firstLocale.prefix(2).description == "ja"
    }

    public static var isUILanguageSimplifiedChinese: Bool {
        guard let firstLocale = Bundle.main.preferredLocalizations.first
        else { return false }
        return firstLocale.contains("zh-Hans") || firstLocale.contains("zh-CN")
    }

    public static var isUILanguageTraditionalChinese: Bool {
        guard let firstLocale = Bundle.main.preferredLocalizations.first
        else { return false }
        return firstLocale.contains("zh-Hant") || firstLocale
            .contains("zh-TW") || firstLocale.contains("zh-HK")
    }
}

extension String {
    public var localizedWithFix: String {
        if contains("旅行者") || localized.contains("旅行者") {
            return "空".localized + " / " + "荧".localized
        }
        characterNameCheck: switch AppConfig.useActualCharacterNames {
        case true where self == "流浪者":
            return "雷电国崩".localized
        case true where contains("流浪者"):
            return replacingOccurrences(of: "流浪者", with: "雷电国崩").localized
        case false
            where self == "流浪者" && !AppConfig.customizedNameForWanderer.isEmpty:
            return AppConfig.customizedNameForWanderer
        default: break characterNameCheck
        }
        guard AppConfig.forceCharacterWeaponNameFixed else { return localized }
        if Locale.isUILanguageSimplifiedChinese {
            if localized == "钟离" {
                return "锺离"
            } else if localized == "钟离・天星" {
                return "锺离・天星"
            } else if localized.contains("钟离") {
                return replacingOccurrences(of: "钟离", with: "锺离")
            }
        } else if Locale.isUILanguageTraditionalChinese {
            if localized == "霧切之回光" {
                return "霧切之迴光"
            }
            if localized.contains("堇") {
                return replacingOccurrences(of: "堇", with: "菫")
            }
        }
        return localized
    }
}

// MARK: - ENCharacterMap.Character Extension

extension ENCharacterMap.Character {
    /// 给定名称翻译表，返回角色姓名。
    public func i18nNameFixed(
        by table: [String: String]? = nil,
        enkaID: Int
    )
        -> String {
        var result = "unknown"
        switch enkaID {
        case 10000007: return "荧".localizedWithFix
        case 10000005: return "空".localizedWithFix
        default: break
        }
        guard let x = table?[NameTextMapHash.description] else { return result }
        result = x.localizedWithFix
        return result
    }
}
