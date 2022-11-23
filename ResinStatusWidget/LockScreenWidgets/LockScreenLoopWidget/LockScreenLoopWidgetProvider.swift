//
//  LockScreenLoopWidgetProvider.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/28.
//

import Foundation
import WidgetKit

struct AccountAndShowWhichInfoIntentEntry: TimelineEntry {
    let date: Date
    let widgetDataKind: WidgetDataKind
    var accountName: String? = nil

    var showWeeklyBosses: Bool = false
    var showTransformer: Bool = false

    let accountUUIDString: String?
}

struct LockScreenLoopWidgetProvider: IntentTimelineProvider {
    // 填入在手表上显示的Widget配置内容，例如："的原粹树脂"
    let recommendationsTag: String

    @available(iOSApplicationExtension 16.0, *)
    func recommendations() -> [IntentRecommendation<SelectAccountAndShowWhichInfoIntent>] {
        let configs = AccountConfigurationModel.shared.fetchAccountConfigs()
        return configs.map { config in
            let intent = SelectAccountAndShowWhichInfoIntent()
            intent.simplifiedMode = true
            intent.account = .init(identifier: config.uuid!.uuidString, display: config.name!+"(\(config.server.rawValue))")
            intent.showTransformer = false
            intent.showWeeklyBosses = false
            return IntentRecommendation(intent: intent, description: config.name!+recommendationsTag.localized)
        }
    }

    func placeholder(in context: Context) -> AccountAndShowWhichInfoIntentEntry {
        AccountAndShowWhichInfoIntentEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil)
    }

    func getSnapshot(for configuration: SelectAccountAndShowWhichInfoIntent, in context: Context, completion: @escaping (AccountAndShowWhichInfoIntentEntry) -> ()) {
        let entry = AccountAndShowWhichInfoIntentEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil)
        completion(entry)
    }

    func getTimeline(for configuration: SelectAccountAndShowWhichInfoIntent, in context: Context, completion: @escaping (Timeline<AccountAndShowWhichInfoIntentEntry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var refreshMinute: Int = 7
        var refreshDate: Date {
            Calendar.current.date(byAdding: .minute, value: refreshMinute, to: currentDate)!
        }

        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()

        guard !configs.isEmpty else {
            let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            return
        }

        guard configuration.account != nil else {
            // 如果还未选择账号，默认获取第一个
            switch configs.first!.server.region {
            case .cn:
                if configuration.simplifiedMode?.boolValue ?? true {
                    configs.first!.fetchSimplifiedResult { simplifiedResult in
                        let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .simplified(result: simplifiedResult), accountName: configs.first!.name, showWeeklyBosses: false , showTransformer: false, accountUUIDString: configs.first!.uuid?.uuidString)
                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                        completion(timeline)
                        print("Widget Fetch succeed")
                    }
                } else {
                    configs.first!.fetchResult { result in
                        let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: configs.first!.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: configs.first!.uuid?.uuidString)
                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                        completion(timeline)
                        print("Widget Fetch succeed")
                    }
                }
            case .global:
                configs.first!.fetchResult { result in
                    let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: configs.first!.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: configs.first!.uuid?.uuidString)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            }
            return
        }

        let selectedAccountUUID = UUID(uuidString: configuration.account!.identifier!)
        print(configs.first!.uuid!, configuration)

        guard let config = configs.first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除账号，Intent没更新就会出现这样的情况
            let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil)
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
                    let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .simplified(result: simplifiedResult), accountName: config.name, showWeeklyBosses: false , showTransformer: false, accountUUIDString: config.uuid?.uuidString)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            } else {
                config.fetchResult { result in
                    let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            }
        case .global:
            config.fetchResult { result in
                let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
                print("Widget Fetch succeed")
            }
        }
    }
}
