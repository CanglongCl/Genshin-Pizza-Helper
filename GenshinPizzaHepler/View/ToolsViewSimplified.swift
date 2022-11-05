//
//  ToolsViewSimplified.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/10/22.
//

import SwiftUI
import SwiftPieChart

struct ToolsViewSimplified: View {
    @EnvironmentObject var viewModel: ViewModel
    var accounts: [Account] { viewModel.accounts }
    @AppStorage("toolViewShowingAccountUUIDString") var showingAccountUUIDString: String?
    var account: Account? {
        accounts.first { account in
            account.config.uuid!.uuidString == showingAccountUUIDString
        }
    }

    var showingCharacterDetail: Bool { viewModel.showCharacterDetailOfAccount != nil }

    @State private var sheetType: SheetTypes? = nil

    var thisAbyssData: SpiralAbyssDetail? { account?.spiralAbyssDetail?.this }
    var lastAbyssData: SpiralAbyssDetail? { account?.spiralAbyssDetail?.last }
    @State private var abyssDataViewSelection: AbyssDataType = .thisTerm

    var ledgerDataResult: LedgerDataFetchResult? { account?.ledgeDataResult }

    var animation: Namespace.ID

    var body: some View {
        NavigationView {
            List {
                accountSection()
                playerDetailSection()
                abyssAndPrimogemNavigator()
                toolsSection()
            }
            .onAppear {
                if !accounts.isEmpty && showingAccountUUIDString == nil {
                    showingAccountUUIDString = accounts.first!.config.uuid!.uuidString
                }
            }
            .sheet(item: $sheetType) { type in
                switch type {
                case .characters:
                    ledgerSheetView()
                case .spiralAbyss:
                    spiralAbyssSheetView()
                case .loginAccountAgainView:
                    NavigationView {
                        AccountDetailView(account: $viewModel.accounts[viewModel.accounts.firstIndex(of: account!)!], isWebShown: true)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("完成") {
                                        sheetType = nil
                                        viewModel.refreshLedgerData()
                                    }
                                }
                            }
                    }
                case .allAvatarList:
                    allAvatarListView()
                }
            }
            .onChange(of: account) { newAccount in
                withAnimation {
                    DispatchQueue.main.async {
                        viewModel.refreshPlayerDetail(for: newAccount!)
                    }
                }
            }
            .toolViewNavigationTitleInIOS15()
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    func accountSection() -> some View {
        if let account = account {
            if let playerDetail = try? account.playerDetailResult?.get() {
                Section {
                    VStack {
                        HStack(spacing: 10) {
                            HomeSourceWebIcon(iconString: playerDetail.basicInfo.profilePictureAvatarIconString)
                                .clipShape(Circle())
                                .frame(height: 60)
                            VStack(alignment: .leading) {
                                Text(playerDetail.basicInfo.nickname)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 5)
                                    .lineLimit(1)
                                Text(playerDetail.basicInfo.signature)
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                            selectAccountManuButton()
                        }
                    }
                } footer: {
                    Text("UID: \(account.config.uid!)")
                }
            } else {
                Section {
                    HStack {
                        Text(account.config.name ?? "")
                        Spacer()
                        selectAccountManuButton()
                    }
                } footer: {
                    Text("UID: \(account.config.uid!)")
                }
            }
        } else {
            Menu {
                ForEach(accounts, id:\.config.id) { account in
                    Button(account.config.name ?? "Name Error") {
                        showingAccountUUIDString = account.config.uuid!.uuidString
                    }
                }
            } label: {
                Label("请先选择账号", systemImage: "arrow.left.arrow.right.circle")
            }
        }
    }

    @ViewBuilder
    func playerDetailSection() -> some View {
        if let account = account {
            if let result = account.playerDetailResult {
                switch result {
                case .success(_):
                    successView()
                case .failure(let error):
                    failureView(error: error)
                }
            } else if !account.fetchPlayerDetailComplete {
                loadingView()
            }
        }
        #if DEBUG
        if (try? account?.playerDetailResult?.get()) == nil {
            Section { allAvatarNavigator() }
        }
        #endif
    }

    @ViewBuilder
    func allAvatarListView() -> some View {
        NavigationView {
//            AllAvatarListSheetView(account: account!, sheetType: $sheetType)
        }
    }

    @ViewBuilder
    func successView() -> some View {
        let playerDetail: PlayerDetail = try! account!.playerDetailResult!.get()
        Section {
            VStack {
                Text("角色展示柜")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Divider()
                if playerDetail.avatars.isEmpty {
                    Text("账号未展示角色")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(playerDetail.avatars, id: \.name) { avatar in
                                VStack {
                                    EnkaWebIcon(iconString: avatar.iconString)
                                        .frame(width: 75, height: 75)
                                        .background(EnkaWebIcon(iconString: avatar.namecardIconString)
                                            .scaledToFill()
                                            .offset(x: -75/3))
                                        .clipShape(Circle())
                                        .contentShape(Circle())
                                        .onTapGesture {
                                            simpleTaptic(type: .medium)
                                            withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 1.0, blendDuration: 0)) {
                                                viewModel.showingCharacterName = avatar.name
                                                viewModel.showCharacterDetailOfAccount = account!
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                #if DEBUG
                Divider()
                allAvatarNavigator()
                #endif
            }
        }
    }

    @ViewBuilder
    func abyssAndPrimogemNavigator() -> some View {
        if let basicInfo: BasicInfos = account?.basicInfo {
            Section {
                HStack(spacing: 30) {
                    VStack {
                        VStack {
                            HStack {
                                Text("深境螺旋")
                                    .font(.footnote)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.bottom, -5)
                            Divider()
                        }
                        VStack(spacing: 7) {
                            AbyssTextLabel(text: "\(basicInfo.stats.spiralAbyss)")
                            if let thisAbyssData = thisAbyssData {
                                HStack {
                                    AbyssStarIcon()
                                        .frame(width: 30, height: 30)
                                    Text("\(thisAbyssData.totalStar)")
                                        .font(.system(.body, design: .rounded))
                                }
                            } else {
                                ProgressView()
                                    .onTapGesture {
                                        viewModel.refreshAbyssAndBasicInfo()
                                    }
                            }
                        }
                        .frame(height: 120)
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))
                    .onTapGesture {
                        simpleTaptic(type: .medium)
                        sheetType = .spiralAbyss
                    }

                    VStack {
                        VStack {
                            HStack {
                                Text("今日入账")
                                    .font(.footnote)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.bottom, -5)
                            Divider()
                        }
                        if let result = ledgerDataResult {
                            VStack(spacing: 10) {
                                switch result {
                                case .success(let data):
                                    PrimogemTextLabel(primogem: data.dayData.currentPrimogems)
                                    MoraTextLabel(mora: data.dayData.currentMora)
                                case .failure(let error):
                                    Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                                        .foregroundColor(.red)
                                    switch error {
                                    case .notLoginError(_, _):
                                        Text("需要重新登陆本账号以查询，点击重新登陆").font(.footnote).multilineTextAlignment(.center)
                                    default:
                                        Text(error.description)
                                    }
                                }
                            }
                            .frame(height: 120)
                            .padding(.bottom, 10)
                        } else {
                            ProgressView()
                                .frame(height: 120)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))
                    .onTapGesture {
                        if let result = ledgerDataResult {
                            switch result {
                            case .success(_):
                                simpleTaptic(type: .medium)
                                sheetType = .characters
                            case .failure(let error):
                                switch error {
                                case .notLoginError(_, _):
                                    simpleTaptic(type: .medium)
                                    sheetType = .loginAccountAgainView
                                default:
                                    viewModel.refreshLedgerData()
                                }
                            }
                        }
                    }
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.white.opacity(0))
        }
    }

    @ViewBuilder
    func ledgerSheetView() -> some View {
        LedgerSheetView(data: try! ledgerDataResult!.get(), sheetType: $sheetType)
    }

    @ViewBuilder
    func spiralAbyssSheetView() -> some View {
        if let thisAbyssData = thisAbyssData, let lastAbyssData = lastAbyssData {
            NavigationView {
                VStack {
                    Picker("", selection: $abyssDataViewSelection) {
                        ForEach(AbyssDataType.allCases, id:\.self) { option in
                            Text(option.rawValue.localized)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    switch abyssDataViewSelection {
                    case .thisTerm:
                        AbyssDetailDataDisplayView(data: thisAbyssData, charMap: viewModel.charMap!)
                    case .lastTerm:
                        AbyssDetailDataDisplayView(data: lastAbyssData, charMap: viewModel.charMap!)
                    }
                }
                .navigationTitle("深境螺旋详情")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("完成") {
                            sheetType = nil
                        }
                    }
                }
            }
        } else {
            ProgressView()
        }
    }



    @ViewBuilder
    func mapNavigationLink() -> some View {
        let hoYoLabMap = NavigationLink(destination:
                                            TeyvatMapWebView(isHoYoLAB: true)
                                .navigationTitle("提瓦特大地图")
                                .navigationBarTitleDisplayMode(.inline)
                            ) {
                                Text("提瓦特大地图")
                            }
        let mysbbsMap = NavigationLink(destination:
                                            TeyvatMapWebView(isHoYoLAB: false)
                                .navigationTitle("提瓦特大地图")
                                .navigationBarTitleDisplayMode(.inline)
                            ) {
                                Text("提瓦特大地图")
                            }
        if let account = account {
            switch account.config.server.region {
            case .cn:
                mysbbsMap
            case .global:
                hoYoLabMap
            }
        } else {
            if Locale.current.identifier == "zh_CN" {
                mysbbsMap
            } else {
                hoYoLabMap
            }
        }
    }

    @ViewBuilder
    func selectAccountManuButton() -> some View {
        if accounts.count > 1 {
            Menu {
                ForEach(accounts, id:\.config.id) { account in
                    Button(account.config.name ?? "Name Error") {
                        withAnimation {
                            showingAccountUUIDString = account.config.uuid!.uuidString
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right.circle")
                    .font(.title2)
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func failureView(error: PlayerDetail.PlayerDetailError) -> some View {
        Section {
            HStack {
                Spacer()
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .foregroundColor(.red)
                    .onTapGesture {
                        if let account = account {
                            viewModel.refreshPlayerDetail(for: account)
                        }
                    }
                Spacer()
            }
        } footer: {
            switch error {
            case .failToGetLocalizedDictionary:
                Text("fail to get localized dictionary")
            case .failToGetCharacterDictionary:
                Text("fail to get character dictionary")
            case .failToGetCharacterData(let message):
                Text(message)
            case .refreshTooFast(let dateWhenRefreshable):
                if dateWhenRefreshable.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate > 0 {
                    let second = Int(dateWhenRefreshable.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate)
                    Text(String(format: NSLocalizedString("请稍等%d秒再刷新", comment: "refresh"), second))
                } else {
                    Text("请下滑刷新")
                }
            }
        }
    }

    @ViewBuilder
    func loadingView() -> some View {
        Section {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }

    @ViewBuilder
    func allAvatarNavigator() -> some View {
        if let basicInfo = account?.basicInfo, let charMap = viewModel.charMap {
            AllAvatarNavigator(basicInfo: basicInfo, charMap: charMap, sheetType: $sheetType)
        }
    }

    @ViewBuilder
    func toolsSection() -> some View {
        Section {
            NavigationLink {
                AbyssDataCollectionView()
            } label: {
                Label {
                    Text("深渊统计")
                } icon: {
                    Image("UI_MarkTower_EffigyChallenge_01").resizable().scaledToFit()
                }
            }
        }
        Section {
            mapNavigationLink()
            Link(destination: isInstallation(urlString: "aliceworkshop://") ? URL(string: "aliceworkshop://app/import?uid=\(account?.config.uid ?? "")")! : URL(string: "https://apps.apple.com/us/app/id1620751192")!) {
                VStack(alignment: .leading) {
                    Text("原神计算器")
                        .foregroundColor(.primary)
                    Text(isInstallation(urlString: "aliceworkshop://") ? "由爱丽丝工坊提供" : "由爱丽丝工坊提供（未安装）")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("小工具")
        }
    }

    func isInstallation(urlString:String?) -> Bool {
            let url = URL(string: urlString!)
            if url == nil {
                return false
            }
            if UIApplication.shared.canOpenURL(url!) {
                return true
            }
            return false
        }
}

private enum SheetTypes: Identifiable {
    var id: Int {
        hashValue
    }

    case spiralAbyss
    case characters
    case loginAccountAgainView
    case allAvatarList
}

private enum AbyssDataType: String, CaseIterable {
    case thisTerm = "本期深渊"
    case lastTerm = "上期深渊"
}

private struct LedgerSheetView: View {
    let data: LedgerData
    @Binding var sheetType: SheetTypes?

    var body: some View {
        NavigationView {
            List {
                LedgerSheetViewList(data: data)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        sheetType = nil
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("原石摩拉账簿").bold()
                }
            }
        }
    }

    private struct LabelInfoProvider: View {
        let title: String
        let icon: String
        let value: Int

        var body: some View {
            HStack {
                Label(title: {Text(title.localized)}) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                }
                Spacer()
                Text("\(value)")
            }
        }
    }

    private struct LedgerSheetViewList: View {
        let data: LedgerData

        var body: some View {
            Section {
                VStack(spacing: 0) {
                    LabelInfoProvider(title: "原石收入", icon: "UI_ItemIcon_Primogem", value: data.dayData.currentPrimogems)
                    if let lastPrimogem = data.dayData.lastPrimogems {
                        let primogemsDifference = data.dayData.currentPrimogems - lastPrimogem
                        HStack {
                            Spacer()
                            Text("较昨日").foregroundColor(.secondary)
                            Text(primogemsDifference > 0 ? "+\(primogemsDifference)" : "\(primogemsDifference)")
                                .foregroundColor(primogemsDifference > 0 ? .green : .red)
                                .opacity(0.8)
                        }.font(.footnote)
                    }
                }
                VStack(spacing: 0) {
                    LabelInfoProvider(title: "摩拉收入", icon: "UI_ItemIcon_Mora", value: data.dayData.currentMora)
                    if let lastMora = data.dayData.lastMora {
                        let moraDifference = data.dayData.currentMora - lastMora
                        HStack {
                            Spacer()
                            Text("较昨日").foregroundColor(.secondary)
                            Text(moraDifference > 0 ? "+\(moraDifference)" : "\(moraDifference)")
                                .foregroundColor(moraDifference > 0 ? .green : .red)
                                .opacity(0.8)
                        }.font(.footnote)
                    }
                }
            } header: {
                HStack {
                    Text("今日入账")
                    Spacer()
                    Text("\(data.date ?? "")")
                }
            } footer: {
                Text("提示：本页面中的数据仅统计充值途径以外获取的资源。数据存在延迟。")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            }

            Section {
                let dayCountThisMonth = Calendar.current.dateComponents([.day], from: Date()).day!
                let primogemsDifference = data.monthData.currentPrimogems - data.monthData.lastPrimogems / dayCountThisMonth
                VStack(spacing: 0) {
                    LabelInfoProvider(title: "原石收入", icon: "UI_ItemIcon_Primogem", value: data.monthData.currentPrimogems)
                    HStack {
                        Spacer()
                        Text("较上月同期").foregroundColor(.secondary)
                        Text(primogemsDifference > 0 ? "+\(primogemsDifference)" : "\(primogemsDifference)")
                            .foregroundColor(primogemsDifference > 0 ? .green : .red)
                            .opacity(0.8)
                    }.font(.footnote)
                }
                VStack(spacing: 0) {
                    let moraDifference: Int = data.monthData.currentMora - data.monthData.lastMora / dayCountThisMonth
                    LabelInfoProvider(title: "摩拉收入", icon: "UI_ItemIcon_Mora", value: data.monthData.currentMora)
                    HStack {
                        Spacer()
                        Text("较上月同期").foregroundColor(.secondary)
                        Text(moraDifference > 0 ? "+\(moraDifference)" : "\(moraDifference)")
                            .foregroundColor(moraDifference > 0 ? .green : .red)
                            .opacity(0.8)
                    }.font(.footnote)
                }
            } header: {
                Text("本月账单 (\(data.dataMonth)月)")
            } footer: {
                HStack {
                    Spacer()
                    PieChartView(
                        values: data.monthData.groupBy.map { Double($0.num) },
                        names: data.monthData.groupBy.map { $0.action },
                        formatter: { value in String(format: "%.0f", value)},
                        colors: [.blue, .green, .orange, .yellow, .purple, .gray, .white],
                        backgroundColor: Color(UIColor.systemGroupedBackground),
                        innerRadiusFraction: 0.6
                    )
                    .padding(.vertical)
                    .frame(height: UIScreen.main.bounds.width > 1000 ? UIScreen.main.bounds.height * 0.9 : UIScreen.main.bounds.height * 0.7)
                    .frame(width: UIScreen.main.bounds.width > 1000 ? 500 : nil)
                    .padding(.top)
                    Spacer()
                }
            }
        }
    }
}

private struct AllAvatarNavigator: View {
    let basicInfo: BasicInfos
    let charMap: [String : ENCharacterMap.Character]
    @Binding var sheetType: SheetTypes?

    var body: some View {
        HStack {
            Text("所有角色")
                .padding(.trailing)
                .font(.footnote)
                .foregroundColor(.primary)
            Spacer()
            HStack(spacing: 3) {
                ForEach(basicInfo.avatars.prefix(5), id: \.id) { avatar in
                    let id = avatar.id
                    EnkaWebIcon(iconString: charMap["\(id)"]?.iconString ?? "")
                        .frame(width: 20, height: 20)
                        .background(EnkaWebIcon(iconString: charMap["\(id)"]?.namecardIconString ?? "")
                            .scaledToFill()
                            .offset(x: -20/3))
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
            }
            .padding(.vertical, 3)
        }
        .onTapGesture {
            sheetType = .allAvatarList
        }
    }
}

private struct PrimogemTextLabel: View {
    let primogem: Int
    @State var labelHeight = CGFloat.zero

    var body: some View {
        HStack {
            Image("UI_ItemIcon_Primogem")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: labelHeight)
            Text("\(primogem)")
                .font(.system(.largeTitle, design: .rounded))
                .overlay(
                    GeometryReader(content: { geometry in
                        Color.clear
                            .onAppear(perform: {
                                self.labelHeight = geometry.frame(in: .local).size.height
                            })
                    })
                )
        }
    }
}

private struct MoraTextLabel: View {
    let mora: Int
    @State var labelHeight = CGFloat.zero

    var body: some View {
        HStack {
            Image("UI_ItemIcon_Mora")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: labelHeight)
            Text("\(mora)")
                .font(.system(.body, design: .rounded))
                .overlay(
                    GeometryReader(content: { geometry in
                        Color.clear
                            .onAppear(perform: {
                                self.labelHeight = geometry.frame(in: .local).size.height
                            })
                    })
                )
        }
    }
}

private struct AbyssTextLabel: View {
    let text: String
    @State var labelHeight = CGFloat.zero

    var body: some View {
        HStack {
            Image("UI_Icon_Tower")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: labelHeight)
            Text(text)
                .font(.system(.largeTitle, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.9)
                .overlay(
                    GeometryReader(content: { geometry in
                        Color.clear
                            .onAppear(perform: {
                                self.labelHeight = geometry.frame(in: .local).size.height
                            })
                    })
                )
        }
    }
}

private struct ToolViewNavigationTitleInIOS15: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            content
                .navigationTitle("披萨工具盒")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension View {
    func toolViewNavigationTitleInIOS15() -> some View {
        modifier(ToolViewNavigationTitleInIOS15())
    }
}
