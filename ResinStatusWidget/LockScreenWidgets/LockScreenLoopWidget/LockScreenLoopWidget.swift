//
//  LockScreenDailyTaskWidget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/9/12.
//

import HBMihoyoAPI
import SwiftUI
import WidgetKit

// MARK: - LockScreenLoopWidget

@available(iOSApplicationExtension 16.0, *)
struct LockScreenLoopWidget: Widget {
    let kind: String = "LockScreenLoopWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectAccountAndShowWhichInfoIntent.self,
            provider: LockScreenLoopWidgetProvider(
                recommendationsTag: "的智能轮换信息"
            )
        ) { entry in
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

// MARK: - LockScreenLoopWidgetView

@available(iOS 16.0, *)
struct LockScreenLoopWidgetView: View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    let entry: LockScreenLoopWidgetProvider.Entry
    var body: some View {
        Group {
            switch dataKind {
            case let .normal(result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenLoopWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    LockScreenLoopWidgetCircular(
                        result: result,
                        showWeeklyBosses: showWeeklyBosses,
                        showTransformer: showTransformer,
                        resinStyle: resinStyle
                    )
                default:
                    EmptyView()
                }
            case let .simplified(result):
                switch family {
                #if os(watchOS)
                case .accessoryCorner:
                    LockScreenLoopWidgetCorner(result: result)
                #endif
                case .accessoryCircular:
                    SimplifiedLockScreenLoopWidgetCircular(
                        result: result,
                        showWeeklyBosses: showWeeklyBosses,
                        showTransformer: showTransformer,
                        resinStyle: resinStyle
                    )
                default:
                    EmptyView()
                }
            }
        }
        .widgetURL(url)
    }

    var dataKind: WidgetDataKind { entry.widgetDataKind }
    var accountName: String? { entry.accountName }
    var showWeeklyBosses: Bool { entry.showWeeklyBosses }
    var showTransformer: Bool { entry.showTransformer }
    var resinStyle: AutoRotationUsingResinWidgetStyle { entry.usingResinStyle }

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

// MARK: - LockScreenLoopWidgetType

enum LockScreenLoopWidgetType {
    case resin
    case expedition
    case dailyTask
    case homeCoin
    case transformer
    case weeklyBosses

    // MARK: Internal

    static func autoChoose(result: FetchResult) -> LockScreenLoopWidgetType {
        switch result {
        case let .success(data):
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
        case .failure:
            return .resin
        }
    }
}

// MARK: - SimplifiedLockScreenLoopWidgetType

enum SimplifiedLockScreenLoopWidgetType {
    case resin
    case expedition
    case dailyTask
    case homeCoin

    // MARK: Internal

    static func autoChoose<T>(result: SimplifiedUserDataContainerResult<T>)
        -> Self where T: SimplifiedUserDataContainer {
        switch result {
        case let .success(data):
            if data.homeCoinInfo.score > data.resinInfo.score {
                return .homeCoin
            } else if data.expeditionInfo.score > data.resinInfo.score {
                return .expedition
            } else if data.resinInfo.score > data.resinInfo.score {
                return .dailyTask
            } else {
                return .resin
            }
        case .failure:
            return .resin
        }
    }
}
