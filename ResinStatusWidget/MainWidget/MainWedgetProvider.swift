//
//  Model.swift
//  Genshin Resin Checker
//
//  Created by 戴藏龙 on 2022/7/12.
//  Widget功能提供

import Foundation
import HBMihoyoAPI
import SwiftUI

import WidgetKit

// MARK: - ResinEntry

struct ResinEntry: TimelineEntry {
    let date: Date
    let widgetDataKind: WidgetDataKind
    let viewConfig: WidgetViewConfiguration
    var accountName: String?
    var relevance: TimelineEntryRelevance? = .init(score: 0)
    let accountUUIDString: String?
}

// MARK: - MainWidgetProvider

struct MainWidgetProvider: IntentTimelineProvider {
    static func calculateRelevanceScore(result: FetchResult) -> Float {
        // 结果为0-1
        switch result {
        case let .success(data):
            return [
                data.resinInfo.score,
                data.transformerInfo.score,
                data.homeCoinInfo.score,
                data.expeditionInfo.score,
                data.dailyTaskInfo.score,
            ].max() ?? 0
        case .failure:
            return 0
        }
    }

    static func calculateRelevanceScore(result: SimplifiedUserDataResult)
        -> Float {
        // 结果为0-1
        switch result {
        case let .success(data):
            return [
                data.resinInfo.score,
                data.homeCoinInfo.score,
                data.expeditionInfo.score,
                data.dailyTaskInfo.score,
            ].max() ?? 0
        case .failure:
            return 0
        }
    }

    func placeholder(in context: Context) -> ResinEntry {
        ResinEntry(
            date: Date(),
            widgetDataKind: .normal(result: .defaultFetchResult),
            viewConfig: .defaultConfig,
            accountName: "荧",
            accountUUIDString: ""
        )
    }

    func getSnapshot(
        for configuration: SelectAccountIntent,
        in context: Context,
        completion: @escaping (ResinEntry) -> ()
    ) {
        let entry = ResinEntry(
            date: Date(),
            widgetDataKind: .normal(result: .defaultFetchResult),
            viewConfig: .defaultConfig,
            accountName: "荧",
            accountUUIDString: ""
        )
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectAccountIntent,
        in context: Context,
        completion: @escaping (Timeline<ResinEntry>) -> ()
    ) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var syncFrequencyInMinute =
            Int(
                UserDefaults(suiteName: "group.GenshinPizzaHelper")?
                    .double(forKey: "mainWidgetSyncFrequencyInMinute") ?? 60
            )
        if syncFrequencyInMinute == 0 { syncFrequencyInMinute = 60 }
        let currentDate = Date()
        let refreshDate = Calendar.current.date(
            byAdding: .minute,
            value: syncFrequencyInMinute,
            to: currentDate
        )!

        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()

        var viewConfig: WidgetViewConfiguration = .defaultConfig

        guard !configs.isEmpty else {
            // 如果还没设置帐号，要求进入App获取帐号
            viewConfig.addMessage("请进入App设置帐号信息")
            let entry = ResinEntry(
                date: currentDate,
                widgetDataKind: .normal(result: .failure(.noFetchInfo)),
                viewConfig: viewConfig,
                accountUUIDString: nil
            )
            let timeline = Timeline(
                entries: [entry],
                policy: .after(refreshDate)
            )
            completion(timeline)
            print("Config is empty")
            return
        }

        guard configuration.accountIntent != nil else {
            print("no account intent got")
            if configs.count == 1 {
                viewConfig = WidgetViewConfiguration(configuration, nil)
                // 如果还未选择帐号且只有一个帐号，默认获取第一个
                getTimelineEntries(config: configs.first!) { entries in
                    completion(.init(
                        entries: entries,
                        policy: .after(refreshDate)
                    ))
                }
            } else {
                // 如果还没设置帐号，要求进入App获取帐号
                viewConfig.addMessage("请长按进入小组件设置帐号信息")
                let entry = ResinEntry(
                    date: currentDate,
                    widgetDataKind: .normal(result: .failure(.noFetchInfo)),
                    viewConfig: viewConfig,
                    accountUUIDString: nil
                )
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(refreshDate)
                )
                completion(timeline)
                print("Need to choose account")
            }
            return
        }

        let selectedAccountUUID = UUID(
            uuidString: configuration.accountIntent!
                .identifier!
        )
        viewConfig = WidgetViewConfiguration(configuration, nil)
        print(configs.first!.uuid!, configuration)

        guard let config = configs
            .first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除帐号，Intent没更新就会出现这样的情况
            viewConfig.addMessage("请长按进入小组件重新设置帐号信息")
            let entry = ResinEntry(
                date: currentDate,
                widgetDataKind: .normal(result: .failure(.noFetchInfo)),
                viewConfig: viewConfig,
                accountUUIDString: nil
            )
            let timeline = Timeline(
                entries: [entry],
                policy: .after(refreshDate)
            )
            completion(timeline)
            print("Need to choose account")
            return
        }

        getTimelineEntries(config: config) { entries in
            completion(.init(entries: entries, policy: .after(refreshDate)))
        }
        return

        func getTimelineEntries(
            config: AccountConfiguration,
            completion: @escaping ([ResinEntry]) -> ()
        ) {
            switch config.server.region {
            case .cn:
                if configuration.simplifiedMode?.boolValue ?? true {
                    getSimplifiedTimelineEntries(config: config) { entries in
                        completion(entries)
                    }
                } else {
                    getNormalTimelineEntries(config: config) { entries in
                        completion(entries)
                    }
                }
            case .global:
                getNormalTimelineEntries(config: config) { entries in
                    completion(entries)
                }
            }
        }

        func getSimplifiedTimelineEntries(
            config: AccountConfiguration,
            completion: @escaping ([ResinEntry]) -> ()
        ) {
            config.fetchSimplifiedResult { result in
                switch result {
                case let .success(data):
                    completion(
                        (0 ... 40).map { index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate =
                                Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            let score = MainWidgetProvider
                                .calculateRelevanceScore(
                                    result: .success(entryData)
                                )
                            let entry = ResinEntry(
                                date: entryDate,
                                widgetDataKind: .simplified(
                                    result: .success(entryData)
                                ),
                                viewConfig: viewConfig,
                                accountName: config.name,
                                relevance: .init(score: score),
                                accountUUIDString: config.uuid?.uuidString
                            )
                            return entry
                        }
                    )
                case .failure:
                    let relevance: TimelineEntryRelevance =
                        .init(
                            score: MainWidgetProvider
                                .calculateRelevanceScore(result: result)
                        )
                    let entry = ResinEntry(
                        date: currentDate,
                        widgetDataKind: .simplified(result: result),
                        viewConfig: viewConfig,
                        accountName: config.name,
                        relevance: relevance,
                        accountUUIDString: config.uuid?.uuidString
                    )
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }

        func getNormalTimelineEntries(
            config: AccountConfiguration,
            completion: @escaping ([ResinEntry]) -> ()
        ) {
            config.fetchResult { result in
                switch result {
                case let .success(data):
                    completion(
                        (0 ... 40).map { index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate =
                                Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            let score = MainWidgetProvider
                                .calculateRelevanceScore(
                                    result: .success(entryData)
                                )
                            let entry = ResinEntry(
                                date: entryDate,
                                widgetDataKind: .normal(
                                    result: .success(entryData)
                                ),
                                viewConfig: viewConfig,
                                accountName: config.name,
                                relevance: .init(score: score),
                                accountUUIDString: config.uuid?.uuidString
                            )
                            return entry
                        }
                    )
                case .failure:
                    let relevance: TimelineEntryRelevance =
                        .init(
                            score: MainWidgetProvider
                                .calculateRelevanceScore(result: result)
                        )
                    let entry = ResinEntry(
                        date: currentDate,
                        widgetDataKind: .normal(result: result),
                        viewConfig: viewConfig,
                        accountName: config.name,
                        relevance: relevance,
                        accountUUIDString: config.uuid?.uuidString
                    )
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }
    }
}
