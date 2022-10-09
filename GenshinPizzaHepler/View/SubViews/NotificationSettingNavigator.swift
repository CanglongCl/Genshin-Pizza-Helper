//
//  NotificationSettingNavigator.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/21.
//  通知设置部分

import SwiftUI

struct NotificationSettingNavigator: View {
    @AppStorage("allowResinNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowResinNotification: Bool = true
    @AppStorage("allowHomeCoinNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowHomeCoinNotification: Bool = true
    @AppStorage("allowExpeditionNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowExpeditionNotification: Bool = true
    @AppStorage("allowWeeklyBossesNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowWeeklyBossesNotification: Bool = true
    @AppStorage("allowTransformerNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowTransformerNotification: Bool = true
    @AppStorage("allowDailyTaskNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowDailyTaskNotification: Bool = true

    @State var isNotificationHintShow: Bool = false
    
    var masterSwitch: Binding<Bool> {
        .init(get: {
            return (allowResinNotification || allowHomeCoinNotification || allowExpeditionNotification || allowWeeklyBossesNotification || allowDailyTaskNotification || allowTransformerNotification)
        }, set: { newValue in
            withAnimation {
                allowResinNotification = newValue
                allowHomeCoinNotification = newValue
                allowExpeditionNotification = newValue
                allowWeeklyBossesNotification = newValue
                allowDailyTaskNotification = newValue
                allowTransformerNotification = newValue
            }
        })
    }
    
    var body: some View {
        Section {
            Toggle(isOn: masterSwitch.animation()) {
                Text("通知推送")
            }
            if masterSwitch.wrappedValue {
                NavigationLink(destination: NotificationSettingView()) {
                    Text("通知推送设置")
                }
                .animation(.easeInOut, value: masterSwitch.wrappedValue)
            }
        } footer: {
            if masterSwitch.wrappedValue {
                Button("通知使用提示") {
                    isNotificationHintShow = true
                }
                .font(.footnote)
            }
        }
        .alert(isPresented: $isNotificationHintShow) {
            Alert(title: Text("通知功能需要帐号添加至小组件后才能生效。\n通知安排与小组件刷新有关，若您的小组件长时间未刷新，推送的通知可能有误。"))
        }
    }
}

