//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import HBMihoyoAPI
import SwiftUI
import WidgetKit

// MARK: - LockScreenExpeditionWidget

@available(iOSApplicationExtension 16.0, *)
struct LockScreenExpeditionWidget: Widget {
    let kind: String = "LockScreenExpeditionWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectOnlyAccountIntent.self,
            provider: LockScreenWidgetProvider(recommendationsTag: "的探索派遣")
        ) { entry in
            LockScreenExpeditionWidgetView(entry: entry)
        }
        .configurationDisplayName("探索派遣")
        .description("探索派遣完成情况")
        #if os(watchOS)
            .supportedFamilies([.accessoryCircular, .accessoryCorner])
        #else
            .supportedFamilies([.accessoryCircular])
        #endif
    }
}

// MARK: - LockScreenExpeditionWidgetView

@available(iOS 16.0, *)
struct LockScreenExpeditionWidgetView: View {
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
                    LockScreenExpeditionWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenExpeditionWidgetCircular(result: result)
                default:
                    EmptyView()
                }
            case let .simplified(result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenExpeditionWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenExpeditionWidgetCircular(result: result)
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
