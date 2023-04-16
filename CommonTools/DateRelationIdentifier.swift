//
//  DateRelationIdentifier.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/26.
//

import Foundation

// MARK: - DateRelationIdentifier

enum DateRelationIdentifier {
    case today
    case tomorrow
    case other

    // MARK: Internal

    static func getRelationIdentifier(
        of date: Date,
        from benchmarkDate: Date = Date()
    )
        -> Self {
        let dayDiffer = Calendar.current.component(.day, from: date) - Calendar
            .current.component(.day, from: benchmarkDate)
        switch dayDiffer {
        case 0: return .today
        case 1: return .tomorrow
        default: return .other
        }
    }
}

extension Date {
    @available(iOS 16, *)
    func getRelativeDateString(benchmarkDate: Date = Date()) -> String {
        let relationIdentifier: DateRelationIdentifier =
            .getRelationIdentifier(of: self)
        let formatter = DateFormatter()
        var component = Locale.Components(locale: Locale.current)
        component.hourCycle = .zeroToTwentyThree
        formatter.locale = Locale(components: component)
        formatter.dateFormat = "H:mm"
        let datePrefix: String
        switch relationIdentifier {
        case .today:
            datePrefix = "今天 "
        case .tomorrow:
            datePrefix = "明天 "
        case .other:
            datePrefix = ""
            formatter.dateFormat = "EEE H:mm"
        }
        return datePrefix.localized + formatter.string(from: self)
    }
}
