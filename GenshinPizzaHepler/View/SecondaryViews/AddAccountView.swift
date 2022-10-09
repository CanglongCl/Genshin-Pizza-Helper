//
//  AddAccountView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/7.
//  添加帐号的View

import SwiftUI
import WebKit

struct AddAccountView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.presentationMode) var presentationMode

    @State private var unsavedName: String = String(format: NSLocalizedString("我的帐号", comment: "my account"))
    @State private var unsavedUid: String = ""
    @State private var unsavedCookie: String = ""
    @State private var unsavedServer: Server = .china
    
    @State private var connectStatus: ConnectStatus = .unknown
    
    @State private var errorInfo: String = ""
    
    @State private var isPresentingConfirm: Bool = false

    @State private var isAlertShow: Bool = false
    @State private var alertType: AlertType = .accountNotSaved

    @State private var isWebShown: Bool = false
    
    @State private var accountsForSelected: [FetchedAccount] = []
    @State private var selectedAccount: FetchedAccount?
    @State private var fetchAccountStatus: FetchAccountStatus = .unknown
    
    @State private var region: Region = .cn
    
    @State private var loginError: FetchError?
    
    @State private var userData: UserData?

    @Namespace var animation

    @State var bgFadeOutAnimation: Bool = false
    
    var body: some View {
        List {
            if (connectStatus == .fail) || (connectStatus == .unknown) {
                Section {
                    if fetchAccountStatus == .progressing {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        Menu {
                            Button("国服") {
                                region = .cn
                                openWebView()
                            }
                            Button("国际服") {
                                region = .global
                                openWebView()
                            }
                        } label: {
                            Text("登录米游社帐号")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("你也可以")
                                .font(.footnote)
                            NavigationLink(destination: AddAccountDetailView(unsavedName: $unsavedName, unsavedUid: $unsavedUid, unsavedCookie: $unsavedCookie, unsavedServer: $unsavedServer, connectStatus: $connectStatus)) {
                                Text("手动设置帐号")
                                    .font(.footnote)
                            }
                        }
                        Divider()
                            .padding(.vertical)
                        Text("关于我们的工作原理")
                            .font(.footnote)
                            .bold()
                        Text("为了请求您的游戏内的数据，我们需要获取您的UID和Cookie，这是获取数据的必要参数。您在接下来的网页登录后，我们会在您的本地和iCloud存储您的个人数据。然后我们通过类似米游社的方式获取您的游戏内的数据信息。我们承诺，您的个人信息不会发送给任何人，包括我们自己。您的个人信息将会是非常安全的。")
                            .font(.footnote)
                        Text("\n")
                            .font(.footnote)
                        Text("关于您的帐号安全")
                            .font(.footnote)
                            .bold()
                        Text("本程序不属于外挂等违法程序。本程序遵守米哈游二次创作规则的相关内容。根据中国原神客服的答复，使用本程序不会造成封号等问题。具体内容参见设置 - FAQ.")
                            .font(.footnote)
                    }
                }
            }
            
            if let loginError = loginError {
                Section(footer: Text("DEBUG：" + loginError.message).foregroundColor(Color(UIColor.systemGray))) {
                    Text(LocalizedStringKey(loginError.description))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            if unsavedUid != "" {
                Section {
                    InfoEditor(title: "自定义帐号名", content: $unsavedName, placeholderText: unsavedName)
                    // 如果该账号绑定的UID不止一个，则显示Picker选择账号
                    if accountsForSelected.count > 1 {
                        Picker("请选择帐号", selection: $selectedAccount) {
                            ForEach(accountsForSelected, id: \.gameUid) { account in
                                Text(account.nickname + "（\(account.gameUid)）")
                                    .tag(account as FetchedAccount?)
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("UID: " + unsavedUid)
                        Spacer()
                        Text(unsavedServer.rawValue)
                    }
                } footer: {
                    Text("你可以自定义显示在小组件上的帐号名称")
                        .font(.footnote)
                }
            }
            
            if (connectStatus == .success) || (connectStatus == .testing) {
                NavigationLink(destination: AddAccountDetailView(unsavedName: $unsavedName, unsavedUid: $unsavedUid, unsavedCookie: $unsavedCookie, unsavedServer: $unsavedServer, connectStatus: $connectStatus)) {
                    Text("查看帐号详情")
                }
            }
            
            if (unsavedUid != "") && (unsavedCookie != "") {
                TestSectionView(connectStatus: $connectStatus, uid: $unsavedUid, cookie: $unsavedCookie, server: $unsavedServer)
            }
            
//            if let userData = userData {
//                GameInfoBlock(userData: userData, accountName: unsavedName, animation: animation, widgetBackground: WidgetBackground.randomNamecardBackground, fetchComplete = true)
//                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                    .aspectRatio(170/364, contentMode: .fill)
//                    .animation(.linear)
//                    .listRowBackground(Color.white.opacity(0))
//            }
            
        }
        .navigationBarTitle("添加帐号", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    if (unsavedUid == "") || (unsavedCookie == "") {
                        alertType = .accountNotSaved
                        isAlertShow.toggle()
                        return
                    }
                    if unsavedName == "" {
                        unsavedName = unsavedUid
                    }
                    if connectStatus != .success {
                        alertType = .accountNotSaved
                        isAlertShow.toggle()
                        return
                    }
                    viewModel.addAccount(name: unsavedName, uid: unsavedUid, cookie: unsavedCookie, server: unsavedServer)
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        ReviewHandler.requestReview()
                    }
                }
            }
        }
        .onAppear {
            if viewModel.accounts.isEmpty {
                alertType = .firstAddAccountHint
                isAlertShow = true
            }
        }
        .alert(isPresented: $isAlertShow) {
            switch alertType {
            case .accountNotSaved:
                return Alert(title: Text("尚未完成帐号设置"))
            case .firstAddAccountHint:
                return Alert(title: Text("添加账号前…"),
                             message: Text("请先确保绑定的米游社账号已开启并能在米游社App中查看“实时便笺”功能"))
            }
        }
        .onChange(of: selectedAccount) { value in
            if let selectedAccount = value {
                unsavedName = selectedAccount.nickname
                unsavedUid = selectedAccount.gameUid
                unsavedServer = Server.id(selectedAccount.region)
            }
            connectStatus = .testing
        }
        .sheet(isPresented: $isWebShown) {
            GetCookieWebView(isShown: $isWebShown, cookie: $unsavedCookie, region: region)
        }
        .onChange(of: isWebShown) { isWebShown in
            DispatchQueue.main.async {
                if !isWebShown {
                    getAccountsForSelect()
                }
            }
            
        }
    }
    
    fileprivate func getAccountsForSelect() {
        guard (unsavedCookie != "") else { loginError = .notLoginError(-100, "未获取到登录信息"); return }
        fetchAccountStatus = .progressing
        API.Features.getUserGameRolesByCookie(unsavedCookie, region) { result in
            switch result {
            case .success(let fetchedAccountArray):
                accountsForSelected = fetchedAccountArray
                if !accountsForSelected.isEmpty { selectedAccount = accountsForSelected.first! }
                loginError = nil
            case .failure(let fetchError):
                loginError = fetchError
            }
            fetchAccountStatus = .finished
        }
    }

    private func openWebView() -> Void {
        isWebShown.toggle()
    }
}

private enum AlertType {
    case accountNotSaved
    case firstAddAccountHint
}

private enum FetchAccountStatus {
    case unknown
    case progressing
    case finished
}
