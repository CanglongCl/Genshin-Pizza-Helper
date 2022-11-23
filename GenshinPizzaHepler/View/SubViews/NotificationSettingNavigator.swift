//
//  NotificationSettingNavigator.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/21.
//  通知设置部分

import SwiftUI

struct NotificationSettingNavigator: View {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("allowResinNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowResinNotification: Bool = true
    @AppStorage("allowHomeCoinNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowHomeCoinNotification: Bool = true
    @AppStorage("allowExpeditionNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowExpeditionNotification: Bool = true
    @AppStorage("allowWeeklyBossesNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowWeeklyBossesNotification: Bool = true
    @AppStorage("allowTransformerNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowTransformerNotification: Bool = true
    @AppStorage("allowDailyTaskNotification", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var allowDailyTaskNotification: Bool = true

    @State var isNotificationHintShow: Bool = false

    @State var allowNotification: Bool = true
    
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
            .disabled(!allowNotification)
            if masterSwitch.wrappedValue && allowNotification {
                NavigationLink(destination: NotificationSettingView()) {
                    Text("通知推送设置")
                }
                .animation(.easeInOut, value: masterSwitch.wrappedValue)
            }
            if !allowNotification {
                Button("前往设置开启通知") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        } footer: {
            if !allowNotification {
                Text("未启用通知，请前往设置开启。")
            } else {
                if masterSwitch.wrappedValue {
                    Button("通知使用提示") {
                        isNotificationHintShow = true
                    }
                    .font(.footnote)
                }
            }
        }
        .alert(isPresented: $isNotificationHintShow) {
            Alert(title: Text("您的通知均在本地创建，并在小组件自动刷新时，或您主动打开App时自动更新。\n长时间未打开App或未使用小组件可能会导致通知不准确。\n小组件若处于简洁模式下，部分通知可能仅能通过打开App刷新。"))
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                allowNotification = settings.authorizationStatus == .provisional || settings.authorizationStatus == .authorized
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    allowNotification = settings.authorizationStatus == .provisional || settings.authorizationStatus == .authorized
                }
            }
        }
    }
}
