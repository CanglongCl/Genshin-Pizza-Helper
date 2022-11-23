//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenExpeditionWidget: Widget {
    let kind: String = "LockScreenExpeditionWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的探索派遣")) { entry in
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

@available (iOS 16.0, *)
struct LockScreenExpeditionWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var dataKind: WidgetDataKind { entry.widgetDataKind }
//    let result: FetchResult = .defaultFetchResult
    var accountName: String? { entry.accountName }

    var url: URL? {
        let errorURL: URL = {
            var components = URLComponents()
            components.scheme = "ophelperwidget"
            components.host = "accountSetting"
            components.queryItems = [
                .init(name: "accountUUIDString", value: entry.accountUUIDString)
            ]
            return components.url!
        }()

        switch entry.widgetDataKind {
        case .normal(let result):
            switch result {
            case .success(_):
                return nil
            case .failure(_):
                return errorURL
            }
        case .simplified(let result):
            switch result {
            case .success(_):
                return nil
            case .failure(_):
                return errorURL
            }
        }
    }


    var body: some View {
        Group {
            switch dataKind {
            case .normal(let result):
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
            case .simplified(let result):
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
}
