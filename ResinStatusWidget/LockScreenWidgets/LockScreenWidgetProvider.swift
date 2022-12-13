//
//  LockScreenWidgetsProvider.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/27.
//

import Foundation
import WidgetKit

struct AccountOnlyEntry: TimelineEntry {
    let date: Date
    let widgetDataKind: WidgetDataKind
    var accountName: String? = nil
    let accountUUIDString: String?
}

struct LockScreenWidgetProvider: IntentTimelineProvider {
    // 填入在手表上显示的Widget配置内容，例如："的原粹树脂"
    let recommendationsTag: String

    @available(iOSApplicationExtension 16.0, *)
    func recommendations() -> [IntentRecommendation<SelectOnlyAccountIntent>] {
        let configs = AccountConfigurationModel.shared.fetchAccountConfigs()
        return configs.map { config in
            let intent = SelectOnlyAccountIntent()
            let useSimplifiedMode = UserDefaults(suiteName: "group.GenshinPizzaHelper")?.bool(forKey: "watchWidgetUseSimplifiedMode") ?? false
            intent.simplifiedMode = useSimplifiedMode as NSNumber
            intent.account = .init(identifier: config.uuid!.uuidString, display: config.name!+"(\(config.server.rawValue))")
            return IntentRecommendation(intent: intent, description: config.name!+recommendationsTag.localized)
        }
    }

    func placeholder(in context: Context) -> AccountOnlyEntry {
        AccountOnlyEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil)
    }

    func getSnapshot(for configuration: SelectOnlyAccountIntent, in context: Context, completion: @escaping (AccountOnlyEntry) -> ()) {
        let entry = AccountOnlyEntry(date: Date(), widgetDataKind: .normal(result: .defaultFetchResult), accountName: "荧", accountUUIDString: nil)
        completion(entry)
    }

    func getTimeline(for configuration: SelectOnlyAccountIntent, in context: Context, completion: @escaping (Timeline<AccountOnlyEntry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var refreshMinute: Int = Int(UserDefaults(suiteName: "group.GenshinPizzaHelper")?.double(forKey: "lockscreenWidgetSyncFrequencyInMinute") ?? 60)
        if refreshMinute == 0 { refreshMinute = 60 }
        var refreshDate: Date {
            Calendar.current.date(byAdding: .minute, value: refreshMinute, to: currentDate)!
        }

        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()
        
        guard !configs.isEmpty else {
            let entry = AccountOnlyEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            return
        }

        guard configuration.account != nil else {
            getTimelineEntries(config: configs.first!) { entries in
                completion(.init(entries: entries, policy: .after(refreshDate)))
            }
            return
        }

        let selectedAccountUUID = UUID(uuidString: configuration.account!.identifier!)
        print(configs.first!.uuid!, configuration)

        guard let config = configs.first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除账号，Intent没更新就会出现这样的情况
            let entry = AccountOnlyEntry(date: currentDate, widgetDataKind: .normal(result: .failure(.noFetchInfo)), accountUUIDString: nil)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
            print("Need to choose account")
            return
        }

        // 正常情况
        getTimelineEntries(config: config) { entries in
            completion(.init(entries: entries, policy: .after(refreshDate)))
        }

        func getTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountOnlyEntry]) -> ()) {
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

        func getSimplifiedTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountOnlyEntry]) -> ()) {
            config.fetchSimplifiedResult { result in
                switch result {
                case .success(let data):
                    completion(
                        (0...40).map({ index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate = Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            return .init(date: entryDate, widgetDataKind: .simplified(result: .success(entryData)), accountName: config.name, accountUUIDString: config.uuid?.uuidString)
                        })
                    )
                case .failure(_):
                    let entry = AccountOnlyEntry(date: currentDate, widgetDataKind: .simplified(result: result), accountName: config.name, accountUUIDString: config.uuid?.uuidString)
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }

        func getNormalTimelineEntries(config: AccountConfiguration, completion: @escaping ([AccountOnlyEntry]) -> ()) {
            config.fetchResult { result in
                switch result {
                case .success(let data):
                    completion(
                        (0...40).map({ index in
                            let timeInterval = TimeInterval(index * 8 * 60)
                            let entryDate = Date(timeIntervalSinceNow: timeInterval)
                            let entryData = data.dataAfter(timeInterval)
                            return .init(date: entryDate, widgetDataKind: .normal(result: .success(entryData)), accountName: config.name, accountUUIDString: config.uuid?.uuidString)
                        })
                    )
                case .failure(_):
                    let entry = AccountOnlyEntry(date: currentDate, widgetDataKind: .normal(result: result), accountName: config.name, accountUUIDString: config.uuid?.uuidString)
                    completion([entry])
                }
                print("Widget Fetch succeed")
            }
        }
    }
}
