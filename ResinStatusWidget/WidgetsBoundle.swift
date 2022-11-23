//
//  WidgetsBoundle.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/10.
//

import WidgetKit
import SwiftUI



@available(iOSApplicationExtension 16.0, watchOSApplicationExtension 9.0, *)
struct WidgetsBundleiOS16: WidgetBundle {
    var body: some Widget {
        #if !os(watchOS)
        MainWidget()
            #if canImport(ActivityKit)
            if #available(iOS 16.1, *) {
                ResinRecoveryActivityWidget()
            }
            #endif
        #else
        AlternativeWatchCornerResinWidget()
        #endif
        LockScreenResinWidget()
        LockScreenLoopWidget()
        LockScreenAllInfoWidget()
        LockScreenHomeCoinWidget()
        LockScreenDailyTaskWidget()
        LockScreenExpeditionWidget()
        AlternativeLockScreenResinWidget()
    }
}

#if !os(watchOS)
struct WidgetsBundleLowerThaniOS16: WidgetBundle {
    var body: some Widget {
        MainWidget()
    }
}
#endif
