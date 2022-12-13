//
//  WidgetSettingView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/11.
//

import SwiftUI

struct WidgetSettingView: View {

    @AppStorage("mainWidgetSyncFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var mainWidgetSyncFrequencyInMinute: Double = 60
    @AppStorage("lockscreenWidgetSyncFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var lockscreenWidgetSyncFrequencyInMinute: Double = 60

    @AppStorage("homeCoinRefreshFrequencyInHour", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var homeCoinRefreshFrequency: Double = 30

    var body: some View {
        List {
            Section {
                SettingSlider(title: "主屏幕小组件同步频率",
                              value: $mainWidgetSyncFrequencyInMinute,
                              valueFormatterString: "每%@",
                              bounds: 30...300,
                              step: 10) { value in
                    let formatter = DateComponentsFormatter()
                    formatter.maximumUnitCount = 2
                    formatter.unitsStyle = .short
                    formatter.zeroFormattingBehavior = .dropAll
                    return formatter.string(from: value*60.0)!
                }
                SettingSlider(title: "锁定屏幕小组件同步频率",
                              value: $lockscreenWidgetSyncFrequencyInMinute,
                              valueFormatterString: "每%@",
                              bounds: 30...300,
                              step: 10) { value in
                    let formatter = DateComponentsFormatter()
                    formatter.maximumUnitCount = 2
                    formatter.unitsStyle = .short
                    formatter.zeroFormattingBehavior = .dropAll
                    return formatter.string(from: value*60.0)!
                }
            } header: {
                Text("小组件同步频率")
            } footer: {
                Text("小组件固定每8分钟刷新一次，同步频率不会影响小组件刷新。建议您尽可能设置更长的同步频率，并在每次游玩后打开App自动同步一次。")
            }

            Section {
                SettingSlider(
                    title: "洞天宝钱回复速度",
                    value: $homeCoinRefreshFrequency,
                    valueFormatterString: "每小时%@个",
                    bounds: 4...30,
                    step: 2) { value in
                        "\(Int(value))"
                    }
            } footer: {
                Text("（仅简洁模式）未正确设置可能导致洞天宝钱通知无法正确触发，洞天宝钱数量不正确。")
            }
        }
        .navigationBarTitle("小组件设置", displayMode: .inline)
    }
}

private struct SettingSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    let title: String
    @Binding var value: V
    var valueFormatterString: String = "%@"
    let bounds: ClosedRange<V>
    let step: V.Stride
    var formatMethod: (V) -> String = { "\($0)" }

    @State var showSlider: Bool = false

    var body: some View {
        HStack {
            Text(title.localized)
            Spacer()
            Button(action: {
                withAnimation{ showSlider.toggle() }
            }) {
                Text(String(format: NSLocalizedString(valueFormatterString, comment: ""), formatMethod(value)))
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

