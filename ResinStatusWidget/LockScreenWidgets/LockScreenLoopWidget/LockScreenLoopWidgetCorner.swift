//
//  LockScreenLoopWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/14.
//

import HBMihoyoAPI
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenLoopWidgetCorner<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch SimplifiedLockScreenLoopWidgetType.autoChoose(result: result) {
        case .resin:
            LockScreenResinWidgetCorner(result: result)
        case .dailyTask:
            LockScreenDailyTaskWidgetCorner(result: result)
        case .expedition:
            LockScreenExpeditionWidgetCorner(result: result)
        case .homeCoin:
            LockScreenHomeCoinWidgetCorner(result: result)
        }
    }
}
