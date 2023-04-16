//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

// MARK: - LockScreenDailyTaskWidget

@available(iOSApplicationExtension 16.0, *)
struct LockScreenDailyTaskWidget: Widget {
    let kind: String = "LockScreenDailyTaskWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectOnlyAccountIntent.self,
            provider: LockScreenWidgetProvider(recommendationsTag: "的每日委托")
        ) { entry in
            LockScreenDailyTaskWidgetView(entry: entry)
        }
        .configurationDisplayName("每日委托")
        .description("每日委托完成情况")
        #if os(watchOS)
            .supportedFamilies([.accessoryCircular, .accessoryCorner])
        #else
            .supportedFamilies([.accessoryCircular])
        #endif
    }
}

// MARK: - LockScreenDailyTaskWidgetView

@available(iOS 16.0, *)
struct LockScreenDailyTaskWidgetView: View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var body: some View {
        Group {
            switch dataKind {
            case let .normal(result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenDailyTaskWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenDailyTaskWidgetCircular(result: result)
                default:
                    EmptyView()
                }
            case let .simplified(result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenDailyTaskWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenDailyTaskWidgetCircular(result: result)
                default:
                    EmptyView()
                }
            }
        }
        .widgetURL(url)
    }

    var dataKind: WidgetDataKind { entry.widgetDataKind }
//    let result: FetchResult = .defaultFetchResult
    var accountName: String? { entry.accountName }

    var url: URL? {
        let errorURL: URL = {
            var components = URLComponents()
            components.scheme = "ophelperwidget"
            components.host = "accountSetting"
            components.queryItems = [
                .init(
                    name: "accountUUIDString",
                    value: entry.accountUUIDString
                ),
            ]
            return components.url!
        }()

        switch entry.widgetDataKind {
        case let .normal(result):
            switch result {
            case .success:
                return nil
            case .failure:
                return errorURL
            }
        case let .simplified(result):
            switch result {
            case .success:
                return nil
            case .failure:
                return errorURL
            }
        }
    }
}
