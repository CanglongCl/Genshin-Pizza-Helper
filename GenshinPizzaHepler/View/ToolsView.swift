//
//  ToolsView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/9/17.
//

import SwiftUI

@available(iOS 15.0, *)
struct ToolsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var accounts: [Account] { viewModel.accounts }
    @State var selectedAccount = 0
    @State private var sheetType: SheetTypes? = nil

    @State var accountCharactersInfo: BasicInfos? = nil
    @State var playerDetailDatas: PlayerDetails? = nil
    @State var charactersDetailMap: ENCharacterMap? = nil
    @State var charactersLocMap: ENCharacterLoc? = nil

    var body: some View {
        NavigationView {
            List {
                if let accountCharactersInfo = accountCharactersInfo, let playerDetailDatas = playerDetailDatas, let charactersDetailMap = charactersDetailMap, let charactersLocMap = charactersLocMap {
                    Section {
                        VStack {
                            HStack {
                                Text("我的角色")
                                    .font(.footnote)
                                Spacer()
                            }
                            Divider()
                        }
                        .listRowSeparator(.hidden)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(accountCharactersInfo.avatars) { avatar in
                                    VStack {
                                        WebImage(urlStr: avatar.image)
                                            .frame(width: 75, height: 75)
                                            .background(avatar.rarity == 5 ? Color.yellow : Color.blue)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom, 10)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }

                    Section {
                        HStack(spacing: 30) {
                            VStack {
                                VStack {
                                    HStack {
                                        Text("深境螺旋")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    Divider()
                                }
                                Text("\(playerDetailDatas.playerInfo.towerFloorIndex)-\(playerDetailDatas.playerInfo.towerLevelIndex)")
                                    .font(.largeTitle)
                                    .frame(height: 120)
                                    .padding(.bottom, 10)
                            }
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))

                            VStack {
                                VStack {
                                    HStack {
                                        Text("游戏内公开信息")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    Divider()
                                }
                                Text("Lv.\(playerDetailDatas.playerInfo.level)")
                                    .font(.largeTitle)
                                    .frame(height: 120)
                                    .padding(.bottom, 10)
                            }
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))
                            .onTapGesture {
                                simpleTaptic(type: .medium)
                                sheetType = .characters
                            }
                        }
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.white.opacity(0))
                }
                
                Section {
                    VStack {
                        HStack {
                            Text("小工具")
                                .font(.footnote)
                            Spacer()
                            Button(action: {

                            }) {
                                Text("自定义")
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Text("原神中日英词典")
                    Text("原神计算器")
                    Text("提瓦特大地图")
                }

            }
            .navigationTitle("原神小工具")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Menu {
                    Picker("选择帐号", selection: $selectedAccount) {
                        ForEach(accounts, id:\.config.id) { account in
                            Text(account.config.name ?? "Name Error")
                                .tag(getAccountItemIndex(item: account))
                        }
                    }
                } label: {
                    Label("选择帐号", systemImage: "arrow.left.arrow.right.circle")
                }
            }
            .onChange(of: selectedAccount) { _ in
                print(accounts[selectedAccount].config.name ?? "")
                fetchSummaryData()
            }
            .onChange(of: accounts) { _ in
                fetchSummaryData()
            }
            .onAppear(perform: fetchSummaryData)
            .sheet(item: $sheetType) { type in
                switch type {
                case .characters:
                    if playerDetailDatas != nil {
                        characterSheetView()
                    } else {
                        Text("Data error")
                    }
                case .spiralAbyss:
                    spiralAbyssSheetView()
                }
            }
        }
    }

    @ViewBuilder
    func characterSheetView() -> some View {
        NavigationView {
            List {
                Section(header: Text("帐号基本信息"), footer: Text(playerDetailDatas!.playerInfo.signature).font(.footnote)) {
                    InfoPreviewer(title: "冒险等阶", content: "\(playerDetailDatas!.playerInfo.level)")
                    InfoPreviewer(title: "世界等级", content: "\(playerDetailDatas!.playerInfo.worldLevel)")
                    InfoPreviewer(title: "成就数量", content: "\(playerDetailDatas!.playerInfo.finishAchievementNum)")
                }
                if playerDetailDatas!.avatarInfoList != nil {
                    Section {
                        TabView {
                            ForEach(playerDetailDatas!.avatarInfoList!, id:\.avatarId) { avatarInfo in
                                CharacterDetailDatasView(characterDetailData: avatarInfo, charactersDetailMap: $charactersDetailMap, charactersLocMap: $charactersLocMap)
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: 500)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                #if os(macOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        sheetType = nil
                    }
                }
                #endif
                ToolbarItem(placement: .principal) {
                    Label {
                        Text(playerDetailDatas!.playerInfo.nickname)
                            .font(.headline)
                    } icon: {
                        WebImage(urlStr: "http://ophelper.top/resource/\(getAvatarIconName(id: playerDetailDatas!.playerInfo.profilePicture.avatarId)).png")
                            .clipShape(Circle())
                    }
                    .labelStyle(.titleAndIcon)
                }
            }
        }
    }

    @ViewBuilder
    func spiralAbyssSheetView() -> some View {
        Text("")
    }

    func getAccountItemIndex(item: Account) -> Int {
        return accounts.firstIndex { currentItem in
            return currentItem.config.id == item.config.id
        } ?? 0
    }

    private func fetchSummaryData() -> Void {
        DispatchQueue.global(qos: .userInteractive).async {
            if !viewModel.accounts.isEmpty {
                API.Features.fetchBasicInfos(region: accounts[selectedAccount].config.server.region, serverID: accounts[selectedAccount].config.server.id, uid: accounts[selectedAccount].config.uid ?? "", cookie: accounts[selectedAccount].config.cookie ?? "") { result in
                    switch result {
                    case .success(let data) :
                        accountCharactersInfo = data
                    case .failure(_):
                        break
                    }
                }
            } else {
                print("accounts is empty")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if !viewModel.accounts.isEmpty {
                API.OpenAPIs.fetchPlayerDatas(accounts[selectedAccount].config.uid ?? "0") { result in
                    switch result {
                    case .success(let data):
                        playerDetailDatas = data
                    case .failure(_):
                        break
                    }
                }
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if !viewModel.accounts.isEmpty {
                API.HomeAPIs.fetchENCharacterDetailDatas() { result in
                    charactersDetailMap = result
                }
                API.HomeAPIs.fetchENCharacterLocDatas() { result in
                    charactersLocMap = result
                }
            }
        }
    }

    func getNameTextMapHash(id: Int) -> Int {
        return charactersDetailMap?.characterDetails["\(id)"]?.NameTextMapHash ?? -1
    }

    func getElement(id: Int) -> String {
        return charactersDetailMap?.characterDetails["\(id)"]?.Element ?? "none"
    }

    func getLocalizedNameFromMapHash(hashId: Int) -> String {
        switch Locale.current.languageCode {
        case "zh":
            return charactersLocMap?.zh_cn.content["\(hashId)"] ?? "Unknown"
        case "en":
            return charactersLocMap?.en.content["\(hashId)"] ?? "Unknown"
        case "ja":
            return charactersLocMap?.ja.content["\(hashId)"] ?? "Unknown"
        case "fr":
            return charactersLocMap?.fr.content["\(hashId)"] ?? "Unknown"
        default:
            return charactersLocMap?.en.content["\(hashId)"] ?? "Unknown"
        }
    }

    func getLocalizedNameFromID(id: Int) -> String {
        let hashId = getNameTextMapHash(id: id)
        return getLocalizedNameFromMapHash(hashId: hashId)
    }

    func getSideIconName(id: Int) -> String {
        return charactersDetailMap?.characterDetails["\(id)"]?.SideIconName ?? "None"
    }

    func getAvatarIconName(id: Int) -> String {
        let sideIconName = getSideIconName(id: id)
        return sideIconName.replacingOccurrences(of: "_Side", with: "")
    }
}

private enum SheetTypes: Identifiable {
    var id: Int {
        hashValue
    }

    case spiralAbyss
    case characters
}
