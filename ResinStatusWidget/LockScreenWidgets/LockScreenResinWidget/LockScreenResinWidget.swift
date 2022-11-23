//
//  LockScreenWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/10.
//

import Foundation

import WidgetKit
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinWidget: Widget {
    let kind: String = "LockScreenResinWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的原粹树脂")) { entry in
            LockScreenResinWidgetView(entry: entry)
        }
        .configurationDisplayName("原粹树脂")
        .description("树脂回复状态")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular, .accessoryCorner])
        #else
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
        #endif
    }
}

@available (iOS 16.0, *)
struct LockScreenResinWidgetView: View {
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
                    LockScreenResinWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenResinWidgetCircular(result: result)
                case .accessoryRectangular:
                    LockScreenResinWidgetRectangular(result: result)
                case .accessoryInline:
                    LockScreenResinWidgetInline(result: result)
                default:
                    EmptyView()
                }
            case .simplified(let result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenResinWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenResinWidgetCircular(result: result)
                case .accessoryRectangular:
                    LockScreenResinWidgetRectangular(result: result)
                case .accessoryInline:
                    LockScreenResinWidgetInline(result: result)
                default:
                    EmptyView()
                }
            }
        }
        .widgetURL(url)

    }
}
