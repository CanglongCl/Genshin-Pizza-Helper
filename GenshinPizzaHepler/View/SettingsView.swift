//
//  SettingsView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/7.
//  设置View

import SwiftUI

struct SettingsView: View {
    @State var editMode: EditMode = .inactive

    @EnvironmentObject var viewModel: ViewModel
    var accounts: [Account] { viewModel.accounts }
    
    @State var isGameBlockAvailable: Bool = true

    @StateObject var storeManager: StoreManager

    @State var isWidgetTipsSheetShow: Bool = false

    @State var isLanguageSettingHintShow: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($viewModel.accounts, id: \.config.uuid) { $account in
                        NavigationLink(destination: AccountDetailView(account: $account)) {
                            AccountInfoView(accountConfig: $account.config)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.deleteAccount(account: accounts[$0]) }
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
                // 通知设置
                NotificationSettingNavigator()

                Section {
                    Button("在App Store评分") {
                        ReviewHandler.requestReview()
                    }
                    NavigationLink(destination: GlobalDonateView(storeManager: storeManager)) {
                        Text("支持我们")
                    }
                }

                Section {
                    Button {
                        isLanguageSettingHintShow = true
                    } label: {
                        Label {
                            HStack {
                                Text("偏好语言")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: WebBroswerView(url: "http://ophelper.top/static/faq.html").navigationTitle("FAQ").navigationBarTitleDisplayMode(.inline)) {
                        Text("常见使用问题（FAQ）")
                    }
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
        .alert(isPresented: $isLanguageSettingHintShow) {
            // 这部分不需要本地化
            Alert(
                title: Text("Before set the language..."),
                message: Text("If you cannot find \"PREFERRED LANGUAGE\" in the destination, add one of supported languages in your phone's [Setting] -> [General] -> [Language & Region] first. \nSupported Languages: Simplified Chinese, English, Japanese, French"),
                primaryButton: .default(Text("OK"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel())
        }
    }
}

private struct EditModeButton: View {
    @Binding var editMode: EditMode
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
