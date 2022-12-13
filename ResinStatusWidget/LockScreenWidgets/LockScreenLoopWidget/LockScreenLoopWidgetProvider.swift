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

    var usingResinStyle: AutoRotationUsingResinWidgetStyle
}

struct LockScreenLoopWidgetProvider: IntentTimelineProvider {
    // 填入在手表上显示的Widget配置内容，例如："的原粹树脂"
    let recommendationsTag: String

    @available(iOSApplicationExtension 16.0, *)
    func recommendations() -> [IntentRecommendation<SelectAccountAndShowWhichInfoIntent>] {
        let configs = AccountConfigurationModel.shared.fetchAccountConfigs()
        return configs.map { config in
            let intent = SelectAccountAndShowWhichInfoIntent()
            let useSimplifiedMode = UserDefaults(suiteName: "group.GenshinPizzaHelper")?.bool(forKey: "watchWidgetUseSimplifiedMode") ?? true
            intent.simplifiedMode = useSimplifiedMode as NSNumber
            intent.account = .init(identifier: config.uuid!.uuidString, display: config.name!+"(\(config.server.rawValue))")
            intent.showTransformer = false
            intent.showWeeklyBosses = false
            return IntentRecommendation(intent: intent, description: config.name!+recommendationsTag.localized)
        }
    }

    func placeholder(in context: Context) -> AccountAndShowWhichInfoIntentEntry {
        AccountAndShowWhichInfoIntentEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil, usingResinStyle: .default_)
    }

    func getSnapshot(for configuration: SelectAccountAndShowWhichInfoIntent, in context: Context, completion: @escaping (AccountAndShowWhichInfoIntentEntry) -> ()) {
        let entry = AccountAndShowWhichInfoIntentEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil, usingResinStyle: .default_)
        completion(entry)
    }

    func getTimeline(for configuration: SelectAccountAndShowWhichInfoIntent, in context: Context, completion: @escaping (Timeline<AccountAndShowWhichInfoIntentEntry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var syncFrequencyInMinute: Int = Int(UserDefaults(suiteName: "group.GenshinPizzaHelper")?.double(forKey: "lockscreenWidgetSyncFrequencyInMinute") ?? 60)
        if syncFrequencyInMinute == 0 { syncFrequencyInMinute = 60 }
        var refreshDate: Date {
            Calendar.current.date(byAdding: .minute, value: syncFrequencyInMinute, to: currentDate)!
        }

        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()

        let style = configuration.usingResinStyle

        guard !configs.isEmpty else {
            let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil, usingResinStyle: style)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            return
        }

        guard configuration.account != nil else {
            let config = configs.first!
            getTimelineEntries(config: config) { entries in
                completion(.init(entries: entries, policy: .after(refreshDate)))
            }
            return
        }

        let selectedAccountUUID = UUID(uuidString: configuration.account!.identifier!)
        print(configs.first!.uuid!, configuration)

        guard let config = configs.first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除账号，Intent没更新就会出现这样的情况
            let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil, usingResinStyle: style)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            print("Need to choose account")
            return
        }

        // 正常情况
        getTimelineEntries(config: config) { entries in
            completion(.init(entries: entries, policy: .after(refreshDate)))
        }

        func getTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountAndShowWhichInfoIntentEntry]) -> ()) {
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

        func getSimplifiedTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountAndShowWhichInfoIntentEntry]) -> ()) {
            config.fetchSimplifiedResult { result in
                switch result {
                case .success(let data):
                    completion(
                        (0...40).map({ index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate = Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            return .init(date: entryDate, widgetDataKind: .simplified(result: .success(entryData)), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString, usingResinStyle: style)
                        })
                    )
                case .failure(_):
                    let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .simplified(result: result), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString, usingResinStyle: style)
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }

        func getNormalTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountAndShowWhichInfoIntentEntry]) -> ()) {
            config.fetchResult { result in
                switch result {
                case .success(let data):
                    completion(
                        (0...40).map({ index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate = Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            return .init(date: entryDate, widgetDataKind: .normal(result: .success(entryData)), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString, usingResinStyle: style)
                        })
                    )
                case .failure(_):
                    let entry = AccountAndShowWhichInfoIntentEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: config.name, showWeeklyBosses: configuration.showWeeklyBosses as! Bool , showTransformer: configuration.showTransformer as! Bool, accountUUIDString: config.uuid?.uuidString, usingResinStyle: style)
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }
    }
}
