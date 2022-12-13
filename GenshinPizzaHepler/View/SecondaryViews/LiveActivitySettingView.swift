//
//  LiveActivitySettingView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/19.
//

import SwiftUI
#if canImport(ActivityKit)
struct LiveActivitySettingView: View {
    @State var isAlertShow: Bool = false

    var body: some View {
        if #available(iOS 16.1, *) {
            Section {
                NavigationLink("树脂计时器设置") {
                    LiveActivitySettingDetailView()
                }
            } footer: {
                Button("树脂计时器是什么？") {
                    isAlertShow.toggle()
                }
                .font(.footnote)
            }
            .alert("若开启，在退出本App时会自动启用一个“实时活动”树脂计时器。默认为顶置的账号，或树脂最少的账号开启计时器。您也可以在“概览”页长按某个账号的卡片手动开启，或启用多个计时器。", isPresented: $isAlertShow) {
                Button("OK") {
                    isAlertShow.toggle()
                }
            }
        }
    }
}

@available(iOS 16.1, *)
struct LiveActivitySettingDetailView: View {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("resinRecoveryLiveActivityUseEmptyBackground", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var resinRecoveryLiveActivityUseEmptyBackground: Bool = false

    @AppStorage("resinRecoveryLiveActivityUseCustomizeBackground", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var resinRecoveryLiveActivityUseCustomizeBackground: Bool = false
    var useRandomBackground: Binding<Bool> {
        .init {
            !resinRecoveryLiveActivityUseCustomizeBackground
        } set: { newValue in
            resinRecoveryLiveActivityUseCustomizeBackground = !newValue
        }
    }

    @AppStorage("autoDeliveryResinTimerLiveActivity") var autoDeliveryResinTimerLiveActivity: Bool = false

    @AppStorage("resinRecoveryLiveActivityShowExpedition", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var resinRecoveryLiveActivityShowExpedition: Bool = true

    @AppStorage("autoUpdateResinRecoveryTimerUsingReFetchData", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var autoUpdateResinRecoveryTimerUsingReFetchData: Bool = true

    @State private var isHelpSheetShow: Bool = false

    @State private var isHowToCloseDynamicIslandAlertShow: Bool = false

    @State private var allowLiveActivity: Bool = ResinRecoveryActivityController.shared.allowLiveActivity

    var body: some View {
        List {
            if !allowLiveActivity {
                Section {
                    Label {
                        Text("实时活动功能未开启")
                    } icon: {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                    }
                    Button("前往设置开启实时活动功能") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }

            Group {
                Section {
                    Toggle("自动启用树脂计时器", isOn: $autoDeliveryResinTimerLiveActivity.animation())
                }
                Section {
                    Button("如何隐藏灵动岛？如何关闭树脂计时器？") {
                        isHowToCloseDynamicIslandAlertShow.toggle()
                    }
                }
                Section {
                    Toggle("展示派遣探索", isOn: $resinRecoveryLiveActivityShowExpedition)
                }
                Section {
                    Toggle("使用透明背景", isOn: $resinRecoveryLiveActivityUseEmptyBackground.animation())
                    if !resinRecoveryLiveActivityUseEmptyBackground {
                        Toggle("随机背景", isOn: useRandomBackground.animation())
                        if resinRecoveryLiveActivityUseCustomizeBackground {
                            NavigationLink("选择背景") {
                                LiveActivityBackgroundPicker()
                            }
                        }
                    }
                } header: {
                    Text("树脂计时器背景")
                }
            }
            .disabled(!allowLiveActivity)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    isHelpSheetShow.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }

            }
        }
        .navigationTitle("树脂计时器设置")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isHelpSheetShow) {
            NavigationView {
                WebBroswerView(url: "http://ophelper.top/static/resin_timer_help.html")
                    .dismissableSheet(isSheetShow: $isHelpSheetShow)
            }
        }
        .alert("隐藏灵动岛 / 关闭树脂计时器", isPresented: $isHowToCloseDynamicIslandAlertShow) {
            Button("OK") {
                isHowToCloseDynamicIslandAlertShow.toggle()
            }
        } message: {
            Text("您可以从左右向中间滑动灵动岛，即可隐藏灵动岛。\n在锁定屏幕上左滑树脂计时器，即可关闭树脂计时器和灵动岛。")
        }
        .onAppear {
            withAnimation {
                allowLiveActivity = ResinRecoveryActivityController.shared.allowLiveActivity
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    withAnimation {
                        allowLiveActivity = ResinRecoveryActivityController.shared.allowLiveActivity
                    }
                }
            }
        }
    }
}

@available(iOS 16.1, *)
struct LiveActivityBackgroundPicker: View {
    let backgroundOptions: [String] = BackgroundOptions.namecards
    @State private var searchText = ""
    @AppStorage("resinRecoveryLiveActivityBackgroundOptions") var resinRecoveryLiveActivityBackgroundOptions: [String] = .init()

    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { backgroundImageName in
                HStack {
                    Label {
                        Text(LocalizedStringKey(backgroundImageName))
                    } icon: {
                        GeometryReader { g in
                            Image(backgroundImageName)
                                .resizable()
                                .scaledToFill()
                                .offset(x: -g.size.width)
                        }
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                    }
                    Spacer()
                    if resinRecoveryLiveActivityBackgroundOptions.contains(backgroundImageName) {
                        Button {
                            resinRecoveryLiveActivityBackgroundOptions.removeAll { name in
                                name == backgroundImageName
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        Button {
                            resinRecoveryLiveActivityBackgroundOptions.append(backgroundImageName)
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.accentColor)
                        }
                    }

                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("选择计时器背景")
        .navigationBarTitleDisplayMode(.inline)
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return backgroundOptions
        } else {
            return backgroundOptions.filter { "\(NSLocalizedString($0, comment: ""))".lowercased().contains(searchText.lowercased()) }
        }
    }
}
#endif
