//
//  LockScreenHomeCoinWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/11.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenHomeCoinWidget: Widget {
    let kind: String = "LockScreenHomeCoinWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的洞天宝钱")) { entry in
            LockScreenHomeCoinWidgetView(entry: entry)
        }
        .configurationDisplayName("洞天宝钱")
        .description("洞天宝钱数量")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
        #else
        .supportedFamilies([.accessoryCircular])
        #endif
    }
}

@available (iOS 16.0, *)
struct LockScreenHomeCoinWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var result: FetchResult { entry.result }
//    let result: FetchResult = .defaultFetchResult
    var accountName: String? { entry.accountName }

    var body: some View {
        switch family {
        #if os(watchOS)
        case .accessoryCorner:
            LockScreenHomeCoinWidgetCorner(result: result)
        #endif
        case .accessoryCircular:
            LockScreenHomeCoinWidgetCircular(result: result)
        default:
            EmptyView()
        }
    }
}
