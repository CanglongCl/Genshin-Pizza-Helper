//
//  LockScreenHomeCoinWidgetCircular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/11.
//

import HBMihoyoAPI
import SwiftUI

// MARK: - LockScreenLoopWidgetCircular

@available(iOSApplicationExtension 16.0, *)
struct LockScreenLoopWidgetCircular: View {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode
    let result: FetchResult

    let showWeeklyBosses: Bool
    let showTransformer: Bool

    let resinStyle: AutoRotationUsingResinWidgetStyle

    var body: some View {
        switch LockScreenLoopWidgetType.autoChoose(result: result) {
        case .resin:
            switch resinStyle {
            case .default_, .unknown:
                AlternativeLockScreenResinWidgetCircular(result: result)
            case .timer:
                LockScreenResinTimerWidgetCircular(result: result)
            case .time:
                LockScreenResinFullTimeWidgetCircular(result: result)
            case .circle:
                LockScreenResinWidgetCircular(result: result)
            }
        case .dailyTask:
            LockScreenDailyTaskWidgetCircular(result: result)
        case .expedition:
            LockScreenExpeditionWidgetCircular(result: result)
        case .homeCoin:
            LockScreenHomeCoinWidgetCircular(result: result)
        case .transformer:
            if showTransformer {
                LockScreenLoopWidgetTransformerCircular(result: result)
            } else {
                AlternativeLockScreenResinWidgetCircular(result: result)
            }
        case .weeklyBosses:
            if showWeeklyBosses {
                LockScreenLoopWidgetWeeklyBossesCircular(result: result)
            } else {
                AlternativeLockScreenResinWidgetCircular(result: result)
            }
        }
    }
}

// MARK: - SimplifiedLockScreenLoopWidgetCircular

@available(iOSApplicationExtension 16.0, *)
struct SimplifiedLockScreenLoopWidgetCircular: View {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode
    let result: SimplifiedUserDataResult

    let showWeeklyBosses: Bool
    let showTransformer: Bool

    let resinStyle: AutoRotationUsingResinWidgetStyle

    var body: some View {
        switch SimplifiedLockScreenLoopWidgetType.autoChoose(result: result) {
        case .resin:
            switch resinStyle {
            case .default_, .unknown:
                AlternativeLockScreenResinWidgetCircular(result: result)
            case .timer:
                LockScreenResinTimerWidgetCircular(result: result)
            case .time:
                LockScreenResinFullTimeWidgetCircular(result: result)
            case .circle:
                LockScreenResinWidgetCircular(result: result)
            }
        case .dailyTask:
            LockScreenDailyTaskWidgetCircular(result: result)
        case .expedition:
            LockScreenExpeditionWidgetCircular(result: result)
        case .homeCoin:
            LockScreenHomeCoinWidgetCircular(result: result)
        }
    }
}
