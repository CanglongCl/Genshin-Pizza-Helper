//
//  Model.swift
//  Genshin Resin Checker
//
//  Created by 戴藏龙 on 2022/7/12.
//  Widget功能提供

import Foundation
import SwiftUI

import WidgetKit

struct ResinEntry: TimelineEntry {
    let date: Date
    let widgetDataKind: WidgetDataKind
    let viewConfig: WidgetViewConfiguration
    var accountName: String? = nil
    var relevance: TimelineEntryRelevance? = .init(score: 0)
    let accountUUIDString: String?
}

struct MainWidgetProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> ResinEntry {
        ResinEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), viewConfig: .defaultConfig, accountName: "荧", accountUUIDString: "")
    }

    func getSnapshot(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (ResinEntry) -> ()) {
        let entry = ResinEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), viewConfig: .defaultConfig, accountName: "荧", accountUUIDString: "")
        completion(entry)
    }

    func getTimeline(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (Timeline<ResinEntry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let refreshFrequencyInMinute: Int = Int(UserDefaults(suiteName: "group.GenshinPizzaHelper")?.double(forKey: "mainWidgetRefreshFrequencyInMinute") ?? 30)
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: refreshFrequencyInMinute, to: currentDate)!
        
        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()
        
        var viewConfig: WidgetViewConfiguration = .defaultConfig
        
        guard !configs.isEmpty else {
            // 如果还没设置账号，要求进入App获取账号
            viewConfig.addMessage("请进入App设置帐号信息")
            let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), viewConfig: viewConfig, accountUUIDString: nil)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            print("Config is empty")
            return
        }
        
        guard configuration.accountIntent != nil else {
            print("no account intent got")
            if configs.count == 1 {
                viewConfig = WidgetViewConfiguration(configuration, nil)
                // 如果还未选择账号且只有一个账号，默认获取第一个
                switch configs.first!.server.region {
                case .cn:
                    if configuration.simplifiedMode?.boolValue ?? true {
                        configs.first!.fetchSimplifiedResult { simplifiedResult in
                            let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: simplifiedResult))
                            let entry = ResinEntry(date: currentDate, widgetDataKind: .simplified(result: simplifiedResult), viewConfig: viewConfig, accountName: configs.first!.name, relevance: relevance, accountUUIDString: configs.first!.uuid?.uuidString)
                            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                            completion(timeline)
                            print("Widget Fetch succeed")
                        }
                    } else {
                        configs.first!.fetchResult { result in
                            let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: result))
                            let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: result), viewConfig: viewConfig, accountName: configs.first!.name, relevance: relevance, accountUUIDString: configs.first?.uuid?.uuidString)
                            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                            completion(timeline)
                            print("Widget Fetch succeed")
                        }
                    }
                case .global:
                    configs.first!.fetchResult { result in
                        let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: result))
                        let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: result), viewConfig: viewConfig, accountName: configs.first!.name, relevance: relevance, accountUUIDString: configs.first?.uuid?.uuidString)
                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                        completion(timeline)
                        print("Widget Fetch succeed")
                    }
                }
            } else {
                // 如果还没设置账号，要求进入App获取账号
                viewConfig.addMessage("请长按进入小组件设置帐号信息")
                let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), viewConfig: viewConfig, accountUUIDString: nil)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
                print("Need to choose account")
            }
            return
        }
        
        let selectedAccountUUID = UUID(uuidString: configuration.accountIntent!.identifier!)
        viewConfig = WidgetViewConfiguration(configuration, nil)
        print(configs.first!.uuid!, configuration)
        
        
        guard let config = configs.first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除账号，Intent没更新就会出现这样的情况
            viewConfig.addMessage("请长按进入小组件重新设置帐号信息")
            let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), viewConfig: viewConfig, accountUUIDString: nil)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            print("Need to choose account")
            return
        }
        
        // 正常情况
        switch config.server.region {
        case .cn:
            if configuration.simplifiedMode?.boolValue ?? true {
                config.fetchSimplifiedResult { simplifiedResult in
                    let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: simplifiedResult))
                    let entry = ResinEntry(date: currentDate, widgetDataKind: .simplified(result: simplifiedResult), viewConfig: viewConfig, accountName: config.name, relevance: relevance, accountUUIDString: config.uuid?.uuidString)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            } else {
                config.fetchResult { result in
                    let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: result))
                    let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: result), viewConfig: viewConfig, accountName: config.name, relevance: relevance, accountUUIDString: config.uuid?.uuidString)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            }
        case .global:
            config.fetchResult { result in
                let relevance: TimelineEntryRelevance = .init(score: MainWidgetProvider.calculateRelevanceScore(result: result))
                let entry = ResinEntry(date: currentDate, widgetDataKind: .normal(result: result), viewConfig: viewConfig, accountName: config.name, relevance: relevance, accountUUIDString: config.uuid?.uuidString)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
                print("Widget Fetch succeed")
            }
        }
    }

    static func calculateRelevanceScore(result: FetchResult) -> Float {
        // 结果为0-1
        switch result {
        case .success(let data):
            return [data.resinInfo.score, data.transformerInfo.score, data.homeCoinInfo.score, data.expeditionInfo.score, data.dailyTaskInfo.score].max() ?? 0
        case .failure(_):
            return 0
        }
    }

    static func calculateRelevanceScore(result: SimplifiedUserDataResult) -> Float {
        // 结果为0-1
        switch result {
        case .success(let data):
            return [data.resinInfo.score, data.homeCoinInfo.score, data.expeditionInfo.score, data.dailyTaskInfo.score].max() ?? 0
        case .failure(_):
            return 0
        }
    }
}

