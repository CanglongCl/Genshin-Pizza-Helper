//
//  WidgetView.swift
//  WidgetView
//
//  Created by 戴藏龙 on 2022/7/13.
//  Widget主View

import WidgetKit
import SwiftUI

struct MainWidget: Widget {
    let kind: String = "WidgetView"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectAccountIntent.self, provider: MainWidgetProvider()) { entry in
            WidgetViewEntryView(entry: entry)
        }
        .configurationDisplayName("原神状态")
        .description("查询树脂恢复状态")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])

    }
}

struct WidgetViewEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: MainWidgetProvider.Entry
    var dataKind: WidgetDataKind { entry.widgetDataKind }
    var viewConfig: WidgetViewConfiguration { entry.viewConfig }
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

        switch dataKind {
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
    
    @ViewBuilder
    var body: some View {
        ZStack {
            WidgetBackgroundView(background: viewConfig.background, darkModeOn: viewConfig.isDarkModeOn)
            switch dataKind {
            case .normal(let result):
                switch result {
                case .success(let userData):
                    WidgetMainView(userData: userData, viewConfig: viewConfig, accountName: accountName)
                case .failure(let error):
                    WidgetErrorView(error: error, message: viewConfig.noticeMessage ?? "")
                }
            case .simplified(let result):
                switch result {
                case .success(let userData):
                    MainWidgetSimplifiedView(userData: userData, viewConfig: viewConfig, accountName: accountName)
                case .failure(let error):
                    WidgetErrorView(error: error, message: viewConfig.noticeMessage ?? "")
                }
            }
        }
        .widgetURL(url)
    }
}
