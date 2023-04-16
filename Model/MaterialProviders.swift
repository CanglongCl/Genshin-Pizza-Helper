//
//  MaterialProviders.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/24.
//  提供今日材料信息的工具类

import Foundation
import HBMihoyoAPI

// MARK: - WeaponOrTalentMaterial

struct WeaponOrTalentMaterial: Equatable {
    struct RelatedItem {
        let imageString: String
        let nameToLocalize: String

        var displayName: String {
            nameToLocalize.localizedWithFix
        }
    }

    let imageString: String
    let nameToLocalize: String
    let weekday: MaterialWeekday
    var relatedItem: [RelatedItem] = []

    var displayName: String {
        nameToLocalize.localizedWithFix
    }

    static func == (
        lhs: WeaponOrTalentMaterial,
        rhs: WeaponOrTalentMaterial
    )
        -> Bool {
        lhs.imageString == rhs.imageString
    }
}

// MARK: - WeaponMaterialProvider

struct WeaponMaterialProvider {
    var weekday: MaterialWeekday = .today()

    var todaysMaterials: [WeaponOrTalentMaterial] {
        WeaponOrTalentMaterial.allWeaponMaterialsOf(weekday: weekday)
    }
}

// MARK: - TalentMaterialProvider

struct TalentMaterialProvider {
    var weekday: MaterialWeekday = .today()

    var todaysMaterials: [WeaponOrTalentMaterial] {
        WeaponOrTalentMaterial.allTalentMaterialsOf(weekday: weekday)
    }
}

// MARK: - MaterialWeekday

enum MaterialWeekday: CaseIterable {
    case mondayAndThursday
    case tuesdayAndFriday
    case wednesdayAndSaturday
    case sunday

    // MARK: Internal

    static func today() -> Self {
        var calendar = Calendar.current
        calendar.timeZone = Server(
            rawValue: UserDefaults(suiteName: "group.GenshinPizzaHelper")?
                .string(forKey: "defaultServer") ?? Server.asia.rawValue
        )?.timeZone() ?? Server.asia.timeZone()
        let isTimePast4am: Bool = Date() > calendar
            .date(bySettingHour: 4, minute: 0, second: 0, of: Date())!
        let todayWeekDayNum = calendar.dateComponents([.weekday], from: Date())
            .weekday!
        let weekdayNum = isTimePast4am ? todayWeekDayNum : (todayWeekDayNum - 1)
        switch weekdayNum {
        case 1:
            return .sunday
        case 2, 5:
            return .mondayAndThursday
        case 3, 6:
            return .tuesdayAndFriday
        case 0, 4, 7:
            return .wednesdayAndSaturday
        default:
            return .sunday
        }
    }

    func tomorrow() -> Self {
        switch self {
        case .mondayAndThursday:
            return .tuesdayAndFriday
        case .tuesdayAndFriday:
            return .wednesdayAndSaturday
        case .wednesdayAndSaturday:
            return .mondayAndThursday
        case .sunday:
            return .mondayAndThursday
        }
    }

    func describe() -> String {
        switch self {
        case .mondayAndThursday:
            return "星期一 & 星期四".localized
        case .tuesdayAndFriday:
            return "星期二 & 星期五".localized
        case .wednesdayAndSaturday:
            return "星期三 & 星期六".localized
        case .sunday:
            return "星期日".localized
        }
    }
}
