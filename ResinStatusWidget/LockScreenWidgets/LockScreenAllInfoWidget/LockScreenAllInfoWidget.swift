//
//  AlternativeWatchCornerResinWidget.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

// MARK: - LockScreenAllInfoWidgetProvider

struct LockScreenAllInfoWidgetProvider: IntentTimelineProvider {
    // 填入在手表上显示的Widget配置内容，例如："的原粹树脂"
    let recommendationsTag: String

    @available(iOSApplicationExtension 16.0, *)
    func recommendations() -> [IntentRecommendation<SelectOnlyAccountIntent>] {
        let configs = AccountConfigurationModel.shared.fetchAccountConfigs()
        return configs.map { config in
            let intent = SelectOnlyAccountIntent()
            intent.simplifiedMode = true
            intent.account = .init(
                identifier: config.uuid!.uuidString,
                display: config.name! + "(\(config.server.rawValue))"
            )
            return IntentRecommendation(
                intent: intent,
                description: config.name! + recommendationsTag.localized
            )
        }
    }

    func placeholder(in context: Context) -> AccountOnlyEntry {
        AccountOnlyEntry(
            date: Date(),
            widgetDataKind: .normal(result: .defaultFetchResult),
            accountName: "荧",
            accountUUIDString: nil
        )
    }

    func getSnapshot(
        for configuration: SelectOnlyAccountIntent,
        in context: Context,
        completion: @escaping (AccountOnlyEntry) -> ()
    ) {
        let entry = AccountOnlyEntry(
            date: Date(),
            widgetDataKind: .normal(result: .defaultFetchResult),
            accountName: "荧",
            accountUUIDString: nil
        )
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectOnlyAccountIntent,
        in context: Context,
        completion: @escaping (Timeline<AccountOnlyEntry>) -> ()
    ) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let refreshMinute =
            Int(
                UserDefaults(suiteName: "group.GenshinPizzaHelper")?
                    .double(
                        forKey: "lockscreenWidgetRefreshFrequencyInMinute"
                    ) ??
                    30
            )
        var refreshDate: Date {
            Calendar.current.date(
                byAdding: .minute,
                value: refreshMinute,
                to: currentDate
            )!
        }

        let accountConfigurationModel = AccountConfigurationModel.shared
        let configs = accountConfigurationModel.fetchAccountConfigs()

        guard !configs.isEmpty else {
            let entry = AccountOnlyEntry(
                date: currentDate,
                widgetDataKind: .normal(result: .failure(.noFetchInfo)),
                accountUUIDString: nil
            )
            let timeline = Timeline(
                entries: [entry],
                policy: .after(refreshDate)
            )
            completion(timeline)
            return
        }

        guard configuration.account != nil else {
            // 如果还未选择帐号，默认获取第一个
            switch configs.first!.server.region {
            case .cn:
                if configuration.simplifiedMode?.boolValue ?? true {
                    configs.first!.fetchSimplifiedResult { simplifiedResult in
                        let entry = AccountOnlyEntry(
                            date: currentDate,
                            widgetDataKind: .simplified(
                                result: simplifiedResult
                            ),
                            accountName: configs.first!.name,
                            accountUUIDString: configs.first!.uuid?.uuidString
                        )
                        let timeline = Timeline(
                            entries: [entry],
                            policy: .after(refreshDate)
                        )
                        #if !os(watchOS) && canImport(ActivityKit)
                        if #available(iOSApplicationExtension 16.1, *) {
                            ResinRecoveryActivityController.shared
                                .updateAllResinRecoveryTimerActivityUsingReFetchData(
                                )
                        }
                        #endif
                        completion(timeline)
                        print("Widget Fetch succeed")
                    }
                } else {
                    configs.first!.fetchResult { result in
                        let entry = AccountOnlyEntry(
                            date: currentDate,
                            widgetDataKind: .normal(result: result),
                            accountName: configs.first!.name,
                            accountUUIDString: configs.first?.uuid?.uuidString
                        )
                        let timeline = Timeline(
                            entries: [entry],
                            policy: .after(refreshDate)
                        )
                        completion(timeline)
                        print("Widget Fetch succeed")
                    }
                }
            case .global:
                configs.first!.fetchResult { result in
                    let entry = AccountOnlyEntry(
                        date: currentDate,
                        widgetDataKind: .normal(result: result),
                        accountName: configs.first!.name,
                        accountUUIDString: configs.first?.uuid?.uuidString
                    )
                    let timeline = Timeline(
                        entries: [entry],
                        policy: .after(refreshDate)
                    )
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            }
            return
        }

        let selectedAccountUUID = UUID(
            uuidString: configuration.account!
                .identifier!
        )
        print(configs.first!.uuid!, configuration)

        guard let config = configs
            .first(where: { $0.uuid == selectedAccountUUID }) else {
            // 有时候删除帐号，Intent没更新就会出现这样的情况
            let entry = AccountOnlyEntry(
                date: currentDate,
                widgetDataKind: .normal(result: .failure(.noFetchInfo)),
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

        // 正常情况
        switch config.server.region {
        case .cn:
            if configuration.simplifiedMode?.boolValue ?? true {
                config.fetchSimplifiedResult { result in
                    let entry = AccountOnlyEntry(
                        date: currentDate,
                        widgetDataKind: .simplified(result: result),
                        accountName: config.name,
                        accountUUIDString: config.uuid?.uuidString
                    )
                    let timeline = Timeline(
                        entries: [entry],
                        policy: .after(refreshDate)
                    )
                    #if !os(watchOS) && canImport(ActivityKit)
                    if #available(iOSApplicationExtension 16.1, *) {
                        ResinRecoveryActivityController.shared
                            .updateAllResinRecoveryTimerActivityUsingReFetchData(
                            )
                    }
                    #endif
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            } else {
                config.fetchResult { result in
                    let entry = AccountOnlyEntry(
                        date: currentDate,
                        widgetDataKind: .normal(result: result),
                        accountName: config.name,
                        accountUUIDString: config.uuid?.uuidString
                    )
                    let timeline = Timeline(
                        entries: [entry],
                        policy: .after(refreshDate)
                    )
                    completion(timeline)
                    print("Widget Fetch succeed")
                }
            }
        case .global:
            config.fetchResult { result in
                let entry = AccountOnlyEntry(
                    date: currentDate,
                    widgetDataKind: .normal(result: result),
                    accountName: config.name,
                    accountUUIDString: config.uuid?.uuidString
                )
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(refreshDate)
                )
                completion(timeline)
                print("Widget Fetch succeed")
            }
        }
    }
}

// MARK: - LockScreenAllInfoWidget

@available(iOSApplicationExtension 16.0, *)
struct LockScreenAllInfoWidget: Widget {
    let kind: String = "LockScreenAllInfoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectOnlyAccountIntent.self,
            provider: LockScreenAllInfoWidgetProvider(
                recommendationsTag: "的综合信息"
            )
        ) { entry in
            LockScreenAllInfoWidgetView(entry: entry)
        }
        .configurationDisplayName("综合信息")
        .description("所有信息，一网打尽")
        .supportedFamilies([.accessoryRectangular])
    }
}

// MARK: - LockScreenAllInfoWidgetView

@available(iOS 16.0, *)
struct LockScreenAllInfoWidgetView: View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode
    let entry: LockScreenAllInfoWidgetProvider.Entry

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
            switch widgetRenderingMode {
            case .fullColor:
                switch dataKind {
                case let .normal(result):
                    switch result {
                    case let .success(data):
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.resin"))
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                    .foregroundColor(
                                        Color("iconColor.expedition")
                                    )
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.expeditionInfo.currentOngoingTask)"
                                    )
                                    Text(
                                        " / \(data.expeditionInfo.maxExpedition)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                    .foregroundColor(
                                        Color("iconColor.homeCoin")
                                    )
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .foregroundColor(
                                        Color("iconColor.dailyTask")
                                    )
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.dailyTaskInfo.finishedTaskNum)"
                                    )
                                    Text(
                                        " / \(data.dailyTaskInfo.totalTaskNum)"
                                    )
                                    .font(.caption)
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .foregroundColor(
                                        Color("iconColor.transformer")
                                    )
                                    .widgetAccentable()
                                Text(
                                    data.transformerInfo.recoveryTime
                                        .describeIntervalShort(
                                            finishedTextPlaceholder: "可使用"
                                        )
                                )
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                    .foregroundColor(
                                        Color("iconColor.weeklyBosses")
                                    )
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.weeklyBossesInfo.hasUsedResinDiscountNum)"
                                    )
                                    Text(
                                        " / \(data.weeklyBossesInfo.resinDiscountNumLimit)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                        }
                    case .failure:
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                case let .simplified(result):
                    switch result {
                    case let .success(data):
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.resin"))
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                    .foregroundColor(
                                        Color("iconColor.expedition")
                                    )
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.expeditionInfo.currentOngoingTask)"
                                    )
                                    Text(
                                        " / \(data.expeditionInfo.maxExpedition)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                    .foregroundColor(
                                        Color("iconColor.homeCoin")
                                    )
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .foregroundColor(
                                        Color("iconColor.dailyTask")
                                    )
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.dailyTaskInfo.finishedTaskNum)"
                                    )
                                    Text(
                                        " / \(data.dailyTaskInfo.totalTaskNum)"
                                    )
                                    .font(.caption)
                                }
                            }
                        }
                    case .failure:
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                }

            default:
                switch dataKind {
                case let .normal(result):
                    switch result {
                    case let .success(data):
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.expeditionInfo.currentOngoingTask)"
                                    )
                                    Text(
                                        " / \(data.expeditionInfo.maxExpedition)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.dailyTaskInfo.finishedTaskNum)"
                                    )
                                    Text(
                                        " / \(data.dailyTaskInfo.totalTaskNum)"
                                    )
                                    .font(.caption)
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(
                                    data.transformerInfo.recoveryTime
                                        .describeIntervalShort(
                                            finishedTextPlaceholder: "可使用"
                                        )
                                )
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.weeklyBossesInfo.hasUsedResinDiscountNum)"
                                    )
                                    Text(
                                        " / \(data.weeklyBossesInfo.resinDiscountNumLimit)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                        }
                    case .failure:
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                case let .simplified(result):
                    switch result {
                    case let .success(data):
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.expeditionInfo.currentOngoingTask)"
                                    )
                                    Text(
                                        " / \(data.expeditionInfo.maxExpedition)"
                                    )
                                    .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(
                                        "\(data.dailyTaskInfo.finishedTaskNum)"
                                    )
                                    Text(
                                        " / \(data.dailyTaskInfo.totalTaskNum)"
                                    )
                                    .font(.caption)
                                }
                            }
                        }
                    case .failure:
                        Grid(
                            alignment: .leadingFirstTextBaseline,
                            horizontalSpacing: 3,
                            verticalSpacing: 2
                        ) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(
                                    alignment: .lastTextBaseline,
                                    spacing: 0
                                ) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
        }
        .widgetURL(url)
    }
}
