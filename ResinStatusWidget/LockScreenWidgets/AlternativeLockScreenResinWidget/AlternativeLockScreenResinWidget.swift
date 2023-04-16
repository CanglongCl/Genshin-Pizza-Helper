//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

// MARK: - AlternativeLockScreenResinWidget

@available(iOSApplicationExtension 16.0, *)
struct AlternativeLockScreenResinWidget: Widget {
    let kind: String = "AlternativeLockScreenResinWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectOnlyAccountIntent.self,
            provider: LockScreenWidgetProvider(recommendationsTag: "的原粹树脂")
        ) { entry in
            AlternativeLockScreenResinWidgetView(entry: entry)
        }
        .configurationDisplayName("原粹树脂")
        .description("另一种样式的原粹树脂小组件")
        .supportedFamilies([.accessoryCircular])
    }
}

// MARK: - AlternativeLockScreenResinWidgetView

@available(iOS 16.0, *)
struct AlternativeLockScreenResinWidgetView: View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    let entry: LockScreenWidgetProvider.Entry

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

    var body: some View {
        Group {
            switch dataKind {
            case let .normal(result):
                AlternativeLockScreenResinWidgetCircular(result: result)
            case let .simplified(result):
                AlternativeLockScreenResinWidgetCircular(result: result)
            }
        }
        .widgetURL(url)
    }
}
