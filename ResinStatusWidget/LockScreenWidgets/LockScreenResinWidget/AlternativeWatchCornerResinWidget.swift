//
//  AlternativeWatchCornerResinWidget.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct AlternativeWatchCornerResinWidget: Widget {
    let kind: String = "AlternativeWatchCornerResinWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的原粹树脂")) { entry in
            AlternativeWatchCornerResinWidgetView(entry: entry)
        }
        .configurationDisplayName("树脂")
        .description("树脂回复状态")
        #if os(watchOS)
        .supportedFamilies([.accessoryCorner])
        #endif
    }
}

@available (iOS 16.0, *)
struct AlternativeWatchCornerResinWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var result: FetchResult { entry.result }
    var accountName: String? { entry.accountName }

    var body: some View {
        switch result {
        case .success(let data):
            Image("icon.resin")
                .resizable()
                .scaledToFit()
                .padding(4)
                .widgetLabel {
                    Gauge(value: Double(data.resinInfo.currentResin), in: 0...Double(data.resinInfo.maxResin)) {
                        Text("原粹树脂")
                    } currentValueLabel: {
                        Text("\(data.resinInfo.currentResin)")
                    } minimumValueLabel: {
                        Text("\(data.resinInfo.currentResin)")
                    } maximumValueLabel: {
                        Text("")
                    }
                }
        case.failure(_):
            Image("icon.resin")
                .resizable()
                .scaledToFit()
                .padding(6)
                .widgetLabel {
                    Gauge(value: 0, in: 0...160) {
                        Text("0")
                    }
                }
        }
    }
}
