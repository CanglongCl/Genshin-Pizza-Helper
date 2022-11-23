//
//  HomeView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/22.
//  展示所有帐号的主页

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel

    @Environment(\.scenePhase) var scenePhase
    var accounts: [Account] { viewModel.accounts }
    @State var eventContents: [EventModel] = []

    var animation: Namespace.ID
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.accounts.isEmpty {
                        NavigationLink(destination: AddAccountView()) {
                            Label("请先添加帐号", systemImage: "plus.circle")
                        }
                        .padding()
                        .blurMaterialBackground()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.top, 30)
                    } else {
                        // MARK: - 今日材料
                        InAppMaterialNavigator()
                            .onChange(of: scenePhase, perform: { newPhase in
                                switch newPhase {
                                case .active:
                                    getCurrentEvent()
                                default:
                                    break
                                }
                            })
                            .onAppear {
                                if eventContents.isEmpty {
                                    getCurrentEvent()
                                }
                            }
                            .padding(.bottom)

                        // MARK: - 当前活动
                        CurrentEventNavigator(eventContents: $eventContents)
                            .padding(.bottom)

                        // MARK: - 账号信息
                        AccountInfoCards(animation: animation)
                    }
                }
            }
            .navigationTitle("披萨小助手")
            .navigationBarTitleDisplayMode(.large)
            
        }
        .navigationViewStyle(.stack)
        .myRefreshable {
            withAnimation {
                DispatchQueue.main.async {
                    viewModel.refreshData()
                }
                getCurrentEvent()
            }
        }
    }

    func getCurrentEvent() -> Void {
        DispatchQueue.global().async {
            API.OpenAPIs.fetchCurrentEvents { result in
                switch result {
                case .success(let events):
                    withAnimation {
                        self.eventContents = [EventModel](events.event.values)
                        self.eventContents = eventContents.sorted {
                            $0.endAt < $1.endAt
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }

}


extension View {
    @ViewBuilder
    func myRefreshable(action: @escaping () -> Void) -> some View {
        if #available(iOS 15, *) {
            self.refreshable {
                action()
            }
        } else {
            self
        }
    }
}

private struct PinedAccountInfoCard: View {
    @EnvironmentObject var viewModel: ViewModel
    var animation: Namespace.ID
    @AppStorage("pinToTopAccountUUIDString") var pinToTopAccountUUIDString: String = ""
    var accountIndex: Int? {
        viewModel.accounts.firstIndex(where: { $0.config.uuid?.uuidString ?? "1" == pinToTopAccountUUIDString })
    }

    @Binding var isErrorAlertShow: Bool
    @Binding var errorMessage: String

    @Binding var isSucceedAlertShow: Bool

    var bindingAccount: Binding<Account>? {
        if let accountIndex = accountIndex {
            return $viewModel.accounts[accountIndex]
        } else {
            return nil
        }
    }

    var body: some View {
        VStack {
            if let accountIndex = accountIndex {
                let account: Account = viewModel.accounts[accountIndex]
                if account != viewModel.showDetailOfAccount {
                    if account.result != nil {
                        switch account.result! {
                        case .success(let userData):
                            // 我也不知道为什么如果不检查的话删除账号会崩溃
                            if account.config.uuid != nil {
                                GameInfoBlock(userData: userData, accountName: account.config.name, accountUUIDString: account.config.uuid!.uuidString, animation: animation, widgetBackground: account.background, fetchComplete: account.fetchComplete)
                                    .padding([.bottom, .horizontal])
                                    .listRowBackground(Color.white.opacity(0))
                                    .onTapGesture {
                                        simpleTaptic(type: .medium)
                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                            viewModel.showDetailOfAccount = account
                                        }
                                    }
                                    .contextMenu {
                                        if #available (iOS 16, *) {
                                            Button("保存图片".localized) {
                                                let view = GameInfoBlockForSave(userData: userData, accountName: account.config.name ?? "", accountUUIDString: account.config.uuid?.uuidString ?? "", animation: animation, widgetBackground: account.background).environment(\.locale, .init(identifier: Locale.current.identifier))
                                                let renderer = ImageRenderer(content: view)
                                                renderer.scale = UIScreen.main.scale
                                                if let image = renderer.uiImage {
                                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                                }
                                            }
                                        }
                                        #if canImport(ActivityKit)
                                        if #available (iOS 16.1, *) {
                                            Button("为该帐号开启树脂计时器") {
                                                do {
                                                    try ResinRecoveryActivityController.shared.createResinRecoveryTimerActivity(for: account)
                                                    isSucceedAlertShow.toggle()
                                                } catch let error {
                                                    errorMessage = error.localizedDescription
                                                    isErrorAlertShow.toggle()
                                                }
                                            }
                                        }
                                        #endif
                                    }
                            }
                        case .failure( _) :
                            HStack {
                                NavigationLink {
                                    AccountDetailView(account: bindingAccount!)
                                } label: {
                                    ZStack {
                                        Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                                            .padding()
                                            .foregroundColor(.red)
                                        HStack {
                                            Spacer()
                                            Text(account.config.name ?? "")
                                                .foregroundColor(Color(UIColor.systemGray4))
                                                .font(.caption2)
                                                .padding(.horizontal)
                                        }
                                    }
                                    .padding([.bottom, .horizontal])
                                }
                            }
                        }
                    } else {
                        ProgressView()
                            .padding([.bottom, .horizontal])
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}

private struct AccountInfoCards: View {
    @EnvironmentObject var viewModel: ViewModel
    var animation: Namespace.ID

    @AppStorage("pinToTopAccountUUIDString") var pinToTopAccountUUIDString: String = ""

    @State var isErrorAlertShow: Bool = false
    @State var errorMessage: String = ""
    @State var isSucceedAlertShow: Bool = false

    var body: some View {
        PinedAccountInfoCard(animation: animation, isErrorAlertShow: $isErrorAlertShow, errorMessage: $errorMessage, isSucceedAlertShow: $isSucceedAlertShow)
            .overlay(
                EmptyView()
                    .alert(isPresented: $isSucceedAlertShow) {
                        Alert(title: Text("创建树脂计时器成功".localized))
                    }
            )
            .overlay(
                EmptyView()
                    .alert(isPresented: $isErrorAlertShow) {
                        Alert(title: Text("ERROR \(errorMessage)"))
                    }
            )
        ForEach($viewModel.accounts, id: \.config.uuid) { $account in
            if account != viewModel.showDetailOfAccount && account != viewModel.accounts.first(where: { $0.config.uuid?.uuidString ?? "1" == pinToTopAccountUUIDString }) {
                if account.result != nil {
                    switch account.result! {
                    case .success(let userData):
                        // 我也不知道为什么如果不检查的话删除账号会崩溃
                        if account.config.uuid != nil {
                            GameInfoBlock(userData: userData, accountName: account.config.name, accountUUIDString: account.config.uuid!.uuidString, animation: animation, widgetBackground: account.background, fetchComplete: account.fetchComplete)
                                .padding([.bottom, .horizontal])
                                .listRowBackground(Color.white.opacity(0))
                                .onTapGesture {
                                    simpleTaptic(type: .medium)
                                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        viewModel.showDetailOfAccount = account
                                    }
                                }
                                .contextMenu {
                                    Button("顶置".localized) {
                                        withAnimation {
                                            pinToTopAccountUUIDString = account.config.uuid!.uuidString
                                        }
                                    }
                                    if #available (iOS 16, *) {
                                        Button("保存图片".localized) {
                                            let view = GameInfoBlockForSave(userData: userData, accountName: account.config.name ?? "", accountUUIDString: account.config.uuid?.uuidString ?? "", animation: animation, widgetBackground: account.background).environment(\.locale, .init(identifier: Locale.current.identifier))
                                            let renderer = ImageRenderer(content: view)
                                            renderer.scale = UIScreen.main.scale
                                            if let image = renderer.uiImage {
                                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                            }
                                        }
                                    }
                                    #if canImport(ActivityKit)
                                    if #available (iOS 16.1, *) {
                                        Button("为该帐号开启树脂计时器") {
                                            do {
                                                try ResinRecoveryActivityController.shared.createResinRecoveryTimerActivity(for: account)
                                                isSucceedAlertShow.toggle()
                                            } catch let error {
                                                errorMessage = error.localizedDescription
                                                isErrorAlertShow.toggle()
                                            }
                                        }
                                    }
                                    #endif
                                }
                        }
                    case .failure( _) :
                        HStack {
                            NavigationLink {
                                AccountDetailView(account: $account)
                            } label: {
                                ZStack {
                                    Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                                        .padding()
                                        .foregroundColor(.red)
                                    HStack {
                                        Spacer()
                                        Text(account.config.name ?? "")
                                            .foregroundColor(Color(UIColor.systemGray4))
                                            .font(.caption2)
                                            .padding(.horizontal)
                                    }
                                }
                                .padding([.bottom, .horizontal])
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .padding([.bottom, .horizontal])
                }
            }



        }
    }
}
