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
    var dataKind: WidgetDataKind { entry.widgetDataKind }
    var accountName: String? { entry.accountName }

    @ViewBuilder
    func resinView(resinInfo: ResinInfo) -> some View {
        Image("icon.resin")
            .resizable()
            .scaledToFit()
            .padding(4)
            .widgetLabel {
                Gauge(value: Double(resinInfo.currentResin), in: 0...Double(resinInfo.maxResin)) {
                    Text("原粹树脂")
                } currentValueLabel: {
                    Text("\(resinInfo.currentResin)")
                } minimumValueLabel: {
                    Text("\(resinInfo.currentResin)")
                } maximumValueLabel: {
                    Text("")
                }
            }
    }

    @ViewBuilder
    func failureView() -> some View {
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

    var body: some View {
        switch dataKind {
        case .normal(let result):
            switch result {
            case .success(let data):
                resinView(resinInfo: data.resinInfo)
            case.failure(_):
                failureView()
            }
        case .simplified(let result):
            switch result {
            case .success(let data):
                resinView(resinInfo: data.resinInfo)
            case.failure(_):
                failureView()
            }
        }

    }
}
