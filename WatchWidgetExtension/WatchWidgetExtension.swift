//
//  WatchWidgetExtension.swift
//  WatchWidgetExtension
//
//  Created by Bill Haku on 2022/9/11.
//

import Intents
import SwiftUI
import WidgetKit

@main
enum WatchWidgetLauncher {
    static func main() {
        WidgetsBundleiOS16.main()
    }
}

// @available(watchOSApplicationExtension 9.0, *)
// struct WidgetsBundleiOS16: WidgetBundle {
//    var body: some Widget {
//        LockScreenResinWidget()
//        LockScreenHomeCoinWidget()
//        AlternativeWatchCornerResinWidget()
//        LockScreenAllInfoWidget()
//        LockScreenDailyTaskWidget()
//    }
// }
