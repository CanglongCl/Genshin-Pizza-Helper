//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenLoopWidget: Widget {
    let kind: String = "LockScreenLoopWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectAccountAndShowWhichInfoIntent.self, provider: LockScreenLoopWidgetProvider(recommendationsTag: "的智能轮换信息")) { entry in
            LockScreenLoopWidgetView(entry: entry)
        }
        .configurationDisplayName("自动轮换")
        .description("自动展示你最需要的信息")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
        #else
        .supportedFamilies([.accessoryCircular])
        #endif
    }
}

@available (iOS 16.0, *)
struct LockScreenLoopWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: LockScreenLoopWidgetProvider.Entry
    var result: FetchResult { entry.result }
    var accountName: String? { entry.accountName }
    var showWeeklyBosses: Bool { entry.showWeeklyBosses }
    var showTransformer: Bool { entry.showTransformer }

    var body: some View {
        switch family {
        #if os(watchOS)
        case .accessoryCorner:
            LockScreenLoopWidgetCorner(result: result)
        #endif
        case .accessoryCircular:
            LockScreenLoopWidgetCircular(result: result, showWeeklyBosses: showWeeklyBosses, showTransformer: showTransformer)
        default:
            EmptyView()
        }

    }
}

enum LockScreenLoopWidgetType {
    case resin
    case expedition
    case dailyTask
    case homeCoin
    case transformer
    case weeklyBosses

    static func autoChoose(result: FetchResult) -> LockScreenLoopWidgetType {
        switch result {
        case .success(let data):
            if data.homeCoinInfo.score > data.resinInfo.score {
                return .homeCoin
            } else if data.expeditionInfo.score > data.resinInfo.score {
                return .expedition
            } else if data.resinInfo.score > data.resinInfo.score {
                return .dailyTask
            } else if data.weeklyBossesInfo.score > data.resinInfo.score {
                return .weeklyBosses
            } else if data.transformerInfo.score > data.resinInfo.score {
                return .transformer
            } else {
                return .resin
            }
        case .failure(_) :
            return .resin
        }
    }
}
