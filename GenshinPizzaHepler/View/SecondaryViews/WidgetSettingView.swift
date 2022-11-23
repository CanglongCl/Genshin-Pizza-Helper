//
//  WidgetSettingView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/11.
//

import SwiftUI

struct WidgetSettingView: View {
    @AppStorage("mainWidgetRefreshFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var mainWidgetRefreshFrequencyInMinute: Double = 30
    @AppStorage("lockscreenWidgetRefreshFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var lockscreenWidgetRefreshFrequencyInMinute: Double = 30

    @AppStorage("homeCoinRefreshFrequencyInHour", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var homeCoinRefreshFrequency: Double = 30

    var body: some View {
        List {
            Section {
                SettingSlider(title: "主屏幕小组件刷新频率",
                                           value: $mainWidgetRefreshFrequencyInMinute,
                                           valueFormatterString: "每%lld分钟",
                                           bounds: 7...120,
                                           step: 1)
                SettingSlider(title: "锁定屏幕小组件刷新频率",
                                           value: $lockscreenWidgetRefreshFrequencyInMinute,
                                           valueFormatterString: "每%lld分钟",
                                           bounds: 7...120,
                                           step: 1)
            } header: {
                Text("小组件刷新频率")
            }

            Section {
                SettingSlider(
                    title: "洞天宝钱回复速度",
                    value: $homeCoinRefreshFrequency,
                    valueFormatterString: "每小时%lld个",
                    bounds: 4...30,
                    step: 2)
            } footer: {
                Text("（仅简洁模式）洞天宝钱回复速度。未正确设置可能导致洞天宝钱通知无法正确触发。")
            }
        }
        .navigationBarTitle("小组件设置", displayMode: .inline)
    }
}

private struct SettingSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    let title: String
    @Binding var value: V
    var valueFormatterString: String = "%lld"
    let bounds: ClosedRange<V>
    let step: V.Stride

    @State var showSlider: Bool = false

    var body: some View {
        HStack {
            Text(title.localized)
            Spacer()
            Button(action: {
                withAnimation{ showSlider.toggle() }
            }) {
                Text(String(format: NSLocalizedString(valueFormatterString, comment: ""), Int(value)))
            }
        }
        if showSlider {
            Slider(value: $value,
                   in: bounds,
                   step: step,
                   label: {
                EmptyView()
            })
        }

    }
}

