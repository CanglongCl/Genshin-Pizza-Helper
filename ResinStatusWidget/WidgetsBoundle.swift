//
//  WidgetsBoundle.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/10.
//

import WidgetKit
import SwiftUI

#if !os(watchOS)
struct WidgetsBundleLowerThaniOS16: WidgetBundle {
    var body: some Widget {
        MainWidget()
        MaterialWidget()
    }
}
#endif

@available(iOSApplicationExtension 16.0, watchOSApplicationExtension 9.0, *)
struct WidgetsBundleiOS16: WidgetBundle {
    var body: some Widget {
        #if !os(watchOS)
        WidgetsBundleLowerThaniOS16().body
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
        SubWidgetsBundleiOS16().body
    }
}

// 因为一个body只能放10个
@available(iOSApplicationExtension 16.0, watchOSApplicationExtension 9.0, *)
struct SubWidgetsBundleiOS16: WidgetBundle {
    var body: some Widget {
//        #if !os(watchOS)
        LockScreenResinTimerWidget()
        LockScreenResinFullTimeWidget()
//        #endif
        LockScreenHomeCoinWidget()
        LockScreenDailyTaskWidget()
        LockScreenExpeditionWidget()
        AlternativeLockScreenResinWidget()
    }
}
