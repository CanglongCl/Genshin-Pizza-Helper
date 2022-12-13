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
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryRectangular])
        #else
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
        #endif
    }
}

@available (iOS 16.0, *)
struct LockScreenHomeCoinWidgetView: View {
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
                    LockScreenHomeCoinWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenHomeCoinWidgetCircular(result: result)
                case .accessoryRectangular:
                    LockScreenHomeCoinWidgetRectangular(result: result)
                default:
                    EmptyView()
                }
            case .simplified(let result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenHomeCoinWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenHomeCoinWidgetCircular(result: result)
                case .accessoryRectangular:
                    LockScreenHomeCoinWidgetRectangular(result: result)
                default:
                    EmptyView()
                }
            }
        }
        .widgetURL(url)


    }
}
