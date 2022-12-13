//
//  WatchWidgetSettingView.swift
//  WatchHelper WatchKit Extension
//
//  Created by 戴藏龙 on 2022/11/25.
//

import Foundation
import SwiftUI
import WidgetKit

struct WatchWidgetSettingView: View {
    @AppStorage("lockscreenWidgetSyncFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var lockscreenWidgetSyncFrequencyInMinute: Double = 60
    @AppStorage("homeCoinRefreshFrequencyInHour", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var homeCoinRefreshFrequency: Double = 30

    @AppStorage("watchWidgetUseSimplifiedMode", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var watchWidgetUseSimplifiedMode: Bool = true

    var lockscreenWidgetRefreshFrequencyFormated: String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: lockscreenWidgetSyncFrequencyInMinute*60.0)!
    }

    var body: some View {
        List {
            Section {
                NavigationLink {
                    QueryFrequencySettingView()
                } label: {
                    HStack {
                        Text("小组件同步频率")
                        Spacer()
                        Text(String(format: NSLocalizedString("每%@", comment: ""), lockscreenWidgetRefreshFrequencyFormated))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            Section {
                Toggle("使用简洁模式", isOn: $watchWidgetUseSimplifiedMode)
            } footer: {
                Text("仅国服用户。更改该项需要重新添加小组件。")
            }
            if watchWidgetUseSimplifiedMode {
                Section {
                    NavigationLink {
                        HomeCoinRecoverySettingView()
                    } label: {
                        HStack {
                            Text("洞天宝钱回复速度")
                            Spacer()
                            Text(String(format: NSLocalizedString("每小时%lld个", comment: ""), Int(homeCoinRefreshFrequency)))
                                .foregroundColor(.accentColor)
                        }
                    }
                } footer: {
                    Text("（仅简洁模式）未正确设置可能导致洞天宝钱数量不准确。")
                }
            }
        }
        .onChange(of: watchWidgetUseSimplifiedMode) { newValue in
            if #available(watchOSApplicationExtension 9.0, *) {
                WidgetCenter.shared.invalidateConfigurationRecommendations()
            }
        }

    }
}

private struct QueryFrequencySettingView: View {
    @AppStorage("lockscreenWidgetSyncFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var lockscreenWidgetSyncFrequencyInMinute: Double = 60

    var lockscreenWidgetRefreshFrequencyFormated: String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: lockscreenWidgetSyncFrequencyInMinute*60.0)!
    }

    var body: some View {
        VStack {
            Text("小组件同步频率").foregroundColor(.accentColor)
            Text(String(format: NSLocalizedString("每%@", comment: ""), lockscreenWidgetRefreshFrequencyFormated))
                .font(.title3)
            Slider(value: $lockscreenWidgetSyncFrequencyInMinute,
                   in: 30...300,
                   step: 10,
                   label: {
                Text("\(lockscreenWidgetSyncFrequencyInMinute)")
            })
        }

    }
}

private struct HomeCoinRecoverySettingView: View {
    @AppStorage("homeCoinRefreshFrequencyInHour", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var homeCoinRefreshFrequency: Double = 30

    var body: some View {
        VStack {
            Text("洞天宝钱回复速度").foregroundColor(.accentColor)
            Text(String(format: NSLocalizedString("每小时%lld个", comment: ""), Int(homeCoinRefreshFrequency)))
                .font(.title3)
            Slider(value: $homeCoinRefreshFrequency,
                   in: 4...30,
                   step: 2,
                   label: {
                Text("\(homeCoinRefreshFrequency)")
            })
        }

    }
}
