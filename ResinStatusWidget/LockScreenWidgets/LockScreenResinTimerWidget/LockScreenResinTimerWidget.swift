//
//  LockScreenResinTimerWidget.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/11/25.
//

import SwiftUI
import WidgetKit

// MARK: - LockScreenResinTimerWidget

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinTimerWidget: Widget {
    let kind: String = "LockScreenResinTimerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectOnlyAccountIntent.self,
            provider: LockScreenWidgetProvider(recommendationsTag: "的原粹树脂回满倒计时")
        ) { entry in
            LockScreenResinTimerWidgetView(entry: entry)
        }
        .configurationDisplayName("原粹树脂回满倒计时")
        .description("展示原粹树脂与恢复到160树脂的倒计时")
        #if os(watchOS)
            .supportedFamilies([.accessoryCircular, .accessoryCircular])
        #else
            .supportedFamilies([.accessoryCircular])
        #endif
    }
}

// MARK: - LockScreenResinTimerWidgetView

@available(iOS 16.0, *)
struct LockScreenResinTimerWidgetView: View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry
    var body: some View {
        switch family {
        case .accessoryCircular:
            Group {
                switch dataKind {
                case let .normal(result):
                    LockScreenResinTimerWidgetCircular(result: result)
                case let .simplified(result):
                    LockScreenResinTimerWidgetCircular(result: result)
                }
            }
            .widgetURL(url)
        #if os(watchOS)
        case .accessoryCorner:
            Group {
                switch dataKind {
                case let .normal(result):
                    LockScreenResinTimerWidgetCircular(result: result)
                case let .simplified(result):
                    LockScreenResinTimerWidgetCircular(result: result)
                }
            }
            .widgetURL(url)
        #endif
        default:
            EmptyView()
        }
    }

    var dataKind: WidgetDataKind { entry.widgetDataKind }
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
