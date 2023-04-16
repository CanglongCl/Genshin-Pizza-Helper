//
//  SettingsView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/7.
//  设置View

import AlertToast
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @State
    var editMode: EditMode = .inactive

    @EnvironmentObject
    var viewModel: ViewModel
    @State
    var isGameBlockAvailable: Bool = true

    @StateObject
    var storeManager: StoreManager

    @State
    var isWidgetTipsSheetShow: Bool = false

    @State
    var isAlertToastShow = false

    var accounts: [Account] { viewModel.accounts }

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(
                        $viewModel.accounts,
                        id: \.config.uuid
                    ) { $account in
                        NavigationLink(
                            destination: AccountDetailView(account: $account)
                        ) {
                            AccountInfoView(account: account)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet
                            .forEach {
                                viewModel.deleteAccount(account: accounts[$0])
                            }
                    }
                    NavigationLink(destination: AddAccountView()) {
                        Label("添加帐号", systemImage: "plus.circle")
                    }
                } header: {
                    HStack {
                        Text("我的帐号")
                        Spacer()
                        EditModeButton(editMode: $editMode)
                    }
                } footer: {
                    Button { isWidgetTipsSheetShow.toggle() } label: {
                        Text("使用小组件遇到了问题？")
                            .multilineTextAlignment(.leading)
                            .font(.footnote)
                    }
                }

                Section {
                    let url: String = {
                        switch Bundle.main.preferredLocalizations.first {
                        case "zh-Hans", "zh-Hant", "zh-HK":
                            return "https://ophelper.top/static/faq.html"
                        default:
                            return "https://ophelper.top/static/faq_en.html"
                        }
                    }()
                    NavigationLink(
                        destination: WebBroswerView(url: url)
                            .navigationTitle("FAQ")
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(
                            "常见使用问题（FAQ）",
                            systemImage: "person.fill.questionmark"
                        )
                    }
                    #if DEBUG
                    Button("debug") {
//                        UserNotificationCenter.shared
//                            .printAllNotificationRequest()
                        isAlertToastShow.toggle()
                    }
                    #endif
                }

                // 该功能对 macCatalyst 无效。
                Section {
                    Button {
                        UIApplication.shared
                            .open(URL(
                                string: UIApplication
                                    .openSettingsURLString
                            )!)
                    } label: {
                        Label {
                            Text("偏好语言")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                    NavigationLink(destination: DisplayOptionsView()) {
                        Label(
                            "界面偏好设置",
                            systemImage: "uiwindow.split.2x1"
                        )
                    }
                    NavigationLink(destination: WidgetSettingView()) {
                        Label(
                            "小组件设置",
                            systemImage: "speedometer"
                        )
                    }
                }

                // 通知设置
                NotificationSettingNavigator()

                #if canImport(ActivityKit)
                LiveActivitySettingView()
                #endif

                Section {
                    Button("在App Store评分") {
                        ReviewHandler.requestReview()
                    }
                    NavigationLink(
                        destination: GlobalDonateView(
                            storeManager: storeManager
                        )
                    ) {
                        Text("支持我们")
                    }
                }

                Group {
                    Section {
                        NavigationLink("隐私设置") {
                            PrivacySettingsView()
                        }
                        NavigationLink("祈愿数据管理") {
                            GachaSetting()
                        }
                    }
                }

                Section {
                    NavigationLink(destination: GuideVideoLinkView()) {
                        Text("App介绍视频")
                    }
                    NavigationLink(destination: ContactUsView()) {
                        Text("开发者与联系方式")
                    }
                }
                // 更多
                NavigationLink(destination: MoreView()) {
                    Text("更多")
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("设置")
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isWidgetTipsSheetShow) {
            WidgetTipsView(isSheetShow: $isWidgetTipsSheetShow)
        }
        .toast(isPresenting: $isAlertToastShow) {
            AlertToast(
                displayMode: .hud,
                type: .complete(.green),
                title: "Complete"
            )
        }
    }
}

// MARK: - EditModeButton

private struct EditModeButton: View {
    @Binding
    var editMode: EditMode

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                if editMode.isEditing {
                    editMode = .inactive
                } else {
                    editMode = .active
                }
            }
        } label: {
            if editMode.isEditing {
                Text("完成")
                    .font(.footnote)
            } else {
                Text("编辑")
                    .font(.footnote)
            }
        }
    }
}
