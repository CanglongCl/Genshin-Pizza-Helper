//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct AlternativeLockScreenResinWidget: Widget {
    let kind: String = "AlternativeLockScreenResinWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的原粹树脂")) { entry in
            AlternativeLockScreenResinWidgetView(entry: entry)
        }
        .configurationDisplayName("原粹树脂")
        .description("另一种样式的原粹树脂小组件")
        .supportedFamilies([.accessoryCircular])
    }
}

@available (iOS 16.0, *)
struct AlternativeLockScreenResinWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var result: FetchResult { entry.result }
    var accountName: String? { entry.accountName }

    var body: some View {
        AlternativeLockScreenResinWidgetCircular(result: result)
    }
}
