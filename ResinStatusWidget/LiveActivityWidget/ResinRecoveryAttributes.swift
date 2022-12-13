//
//  ResinRecoveryAttributes.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/18.
//

import Foundation
#if canImport(ActivityKit)
import ActivityKit

@available(iOS 16.1, *)
struct ResinRecoveryAttributes: ActivityAttributes {
    public typealias ResinRecoveryState = ContentState

    public struct ContentState: Codable, Hashable {
        let resinCountWhenUpdated: Int
        let resinRecoveryTimeUntilFullInSecondWhenUpdated: TimeInterval
        let updatedTime: Date
        let expeditionAllCompleteTimeInterval: TimeInterval
        let showExpedition: Bool

        let background: ResinRecoveryActivityBackground

        init(resinInfo: ResinInfo, expeditionInfo: ExpeditionInfo, showExpedition: Bool, background: ResinRecoveryActivityBackground) {
            resinCountWhenUpdated = resinInfo.currentResin
            resinRecoveryTimeUntilFullInSecondWhenUpdated = TimeInterval(resinInfo.recoveryTime.second)
            updatedTime = resinInfo.updateDate
            expeditionAllCompleteTimeInterval = TimeInterval(expeditionInfo.allCompleteTime.second)
            self.showExpedition = showExpedition
            self.background = background
        }
    }

    let accountName: String
    let accountUUID: UUID
}

@available(iOS 16.1, *)
extension ResinRecoveryAttributes.ResinRecoveryState {
    /// 求余获得**更新时**距离下一个树脂的TimeInterval
    var timeIntervalFromNextResinWhenUpdated: TimeInterval {
        Double(resinRecoveryTimeUntilFullInSecondWhenUpdated).truncatingRemainder(dividingBy: Double(8*60))
    }

    /// 距离信息更新时的TimeInterval
    var timeIntervalFromUpdatedTime: TimeInterval {
        Date().timeIntervalSince(updatedTime)
    }

    /// 当前距离树脂回满需要的TimeInterval
    var resinRecoveryTimeIntervalUntilFull: TimeInterval {
        resinRecoveryTimeUntilFullInSecondWhenUpdated - timeIntervalFromUpdatedTime
    }

    /// 树脂回满的时间点
    var resinFullTime: Date {
        updatedTime.addingTimeInterval(resinRecoveryTimeUntilFullInSecondWhenUpdated)
    }

    /// 当前还需多少树脂才能回满
    var resinToFull: Int {
        Int( ceil( resinRecoveryTimeIntervalUntilFull / (8*60) ) )
    }

    /// 当前树脂数量
    var currentResin: Int {
        160 - resinToFull
    }

    /// 当前距离下个树脂回复所需时间
    var nextResinRecoveryTimeInterval: TimeInterval {
        resinRecoveryTimeIntervalUntilFull.truncatingRemainder(dividingBy: 8*60)
    }

    /// 下个树脂回复的时间点
    var nextResinRecoveryTime: Date {
        Date().addingTimeInterval(nextResinRecoveryTimeInterval)
    }

    /// 下一20倍数树脂
    var next20ResinCount: Int {
        Int(ceil((Double(currentResin)+0.01) / 20.0)) * 20
    }

    var showNext20Resin: Bool {
        next20ResinCount != 160
    }

    /// 下一20倍数树脂回复所需时间
    var next20ResinRecoveryTimeInterval: TimeInterval {
        resinRecoveryTimeIntervalUntilFull.truncatingRemainder(dividingBy: 8*60*20)
    }

    /// 下一20倍数树脂回复时间点
    var next20ResinRecoveryTime: Date {
        Date().addingTimeInterval(next20ResinRecoveryTimeInterval)
    }

    var allExpeditionCompleteTime: Date {
        Date().addingTimeInterval(expeditionAllCompleteTimeInterval)
    }

    var showExpeditionInfo: Bool {
        showExpedition
    }
}

enum ResinRecoveryActivityBackground: Codable, Equatable, Hashable {
    case ramdom
    case customize([String])
    case noBackground
}
#endif
