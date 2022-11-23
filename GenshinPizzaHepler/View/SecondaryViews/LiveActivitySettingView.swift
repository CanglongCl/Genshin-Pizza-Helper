//
//  LiveActivitySettingView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/19.
//

import SwiftUI
#if canImport(ActivityKit)
struct LiveActivitySettingView: View {
    @AppStorage("autoDeliveryResinTimerLiveActivity") var autoDeliveryResinTimerLiveActivity: Bool = true

    @State var isAlertShow: Bool = false
    var body: some View {
        if #available(iOS 16.1, *) {
            Section {
                Toggle("自动启用树脂计时器", isOn: $autoDeliveryResinTimerLiveActivity.animation())
                    .disabled(!ResinRecoveryActivityController.shared.allowLiveActivity)
                if !ResinRecoveryActivityController.shared.allowLiveActivity {
                    Button("前往设置开启实时活动功能") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                } else {
                    NavigationLink("树脂计时器设置") {
                        LiveActivitySettingDetailView()
                    }
                }
            } footer: {
                if !ResinRecoveryActivityController.shared.allowLiveActivity {
                    Text("实时活动功能未开启，请前往设置开启。")
                } else {
                    Button("树脂计时器是什么？") {
                        isAlertShow.toggle()
                    }
                    .font(.footnote)
                }
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
    @AppStorage("resinRecoveryLiveActivityUseEmptyBackground") var resinRecoveryLiveActivityUseEmptyBackground: Bool = false

    @AppStorage("resinRecoveryLiveActivityUseCustomizeBackground") var resinRecoveryLiveActivityUseCustomizeBackground: Bool = false
    var useRandomBackground: Binding<Bool> {
        .init {
            !resinRecoveryLiveActivityUseCustomizeBackground
        } set: { newValue in
            resinRecoveryLiveActivityUseCustomizeBackground = !newValue
        }
    }


    @AppStorage("resinRecoveryLiveActivityShowExpedition") var resinRecoveryLiveActivityShowExpedition: Bool = true

    var body: some View {
        List {
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
        .navigationTitle("树脂计时器设置")
        .navigationBarTitleDisplayMode(.inline)
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



extension [String]: RawRepresentable {
    public typealias RawValue = String
    public var rawValue: RawValue {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)!
        } else {
            return String(data: try! encoder.encode([String].init()), encoding: .utf8)!
        }
    }

    public init?(rawValue: RawValue) {
        let decoder = JSONDecoder()
        if let data = rawValue.data(using: .utf8),
            let result = try? decoder.decode([String].self, from: data) {
            self = result
        } else {
            self = []
        }
    }
}
#endif
