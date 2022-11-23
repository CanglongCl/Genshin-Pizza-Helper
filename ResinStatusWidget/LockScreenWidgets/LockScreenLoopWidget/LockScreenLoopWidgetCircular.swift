//
//  LockScreenHomeCoinWidgetCircular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/11.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenLoopWidgetCircular: View {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    let result: FetchResult

    let showWeeklyBosses: Bool
    let showTransformer: Bool

    var body: some View {
        switch LockScreenLoopWidgetType.autoChoose(result: result) {
        case .resin:
            AlternativeLockScreenResinWidgetCircular(result: result)
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

@available(iOSApplicationExtension 16.0, *)
struct SimplifiedLockScreenLoopWidgetCircular: View {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    let result: SimplifiedUserDataResult

    let showWeeklyBosses: Bool
    let showTransformer: Bool

    var body: some View {
        switch SimplifiedLockScreenLoopWidgetType.autoChoose(result: result) {
        case .resin:
            AlternativeLockScreenResinWidgetCircular(result: result)
        case .dailyTask:
            LockScreenDailyTaskWidgetCircular(result: result)
        case .expedition:
            LockScreenExpeditionWidgetCircular(result: result)
        case .homeCoin:
            LockScreenHomeCoinWidgetCircular(result: result)
        }
    }
}
