//
//  AbyssDataCollectionView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/16.
//

import HBMihoyoAPI
import HBPizzaHelperAPI
import SwiftUI

// MARK: - AbyssDataCollectionViewModel

class AbyssDataCollectionViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        self.showingType = .abyssAvatarsUtilization
        getData()
    }

    // MARK: Internal

    enum ShowingData: String, CaseIterable, Identifiable {
        case abyssAvatarsUtilization = "深渊角色使用率"
        case pvpUtilization = "未重开玩家使用率"
        case teamUtilization = "深渊队伍使用率"
        case fullStarHoldingRate = "满星玩家持有率"
        case holdingRate = "全员角色持有率"

        // MARK: Internal

        var id: String { rawValue }
    }

    // MARK: - 所有用户持有率

    @Published
    var avatarHoldingResult: AvatarHoldingReceiveDataFetchModelResult?

    // MARK: - 满星用户持有率

    @Published
    var fullStaAvatarHoldingResult: AvatarHoldingReceiveDataFetchModelResult?

    // MARK: - 深渊使用率

    @Published
    var utilizationDataFetchModelResult: UtilizationDataFetchModelResult?

    // MARK: - 深渊队伍使用率

    @Published
    var teamUtilizationDataFetchModelResult: TeamUtilizationDataFetchModelResult?

    // MARK: - 未重开使用率

    @Published
    var pvpUtilizationDataFetchModelResult: UtilizationDataFetchModelResult?

    @Published
    var showingType: ShowingData {
        didSet {
            getData()
        }
    }

    @Published
    var holdingParam: AvatarHoldingAPIParameters = .init() {
        didSet { getAvatarHoldingResult() }
    }

    @Published
    var fullStarHoldingParam: FullStarAPIParameters = .init() {
        didSet { getFullStarHoldingResult() }
    }

    @Published
    var utilizationParams: UtilizationAPIParameters = .init() {
        didSet { getUtilizationResult() }
    }

    @Published
    var teamUtilizationParams: TeamUtilizationAPIParameters =
        .init() {
        didSet { getTeamUtilizationResult() }
    }

    @Published
    var pvpUtilizationParams: UtilizationAPIParameters = .init() {
        didSet { getPVPUtilizationResult() }
    }

    var paramsDescription: String {
        switch showingType {
        case .fullStarHoldingRate:
            return fullStarHoldingParam.describe()
        case .holdingRate:
            return holdingParam.describe()
        case .abyssAvatarsUtilization, .pvpUtilization:
            return utilizationParams.describe()
        case .teamUtilization:
            return teamUtilizationParams.describe()
        }
    }

    var totalDataCount: Int {
        switch showingType {
        case .fullStarHoldingRate:
            return (try? fullStaAvatarHoldingResult?.get().data.totalUsers) ?? 0
        case .holdingRate:
            return (try? avatarHoldingResult?.get().data.totalUsers) ?? 0
        case .abyssAvatarsUtilization:
            return (
                try? utilizationDataFetchModelResult?.get().data
                    .totalUsers
            ) ?? 0
        case .teamUtilization:
            return (
                try? teamUtilizationDataFetchModelResult?.get().data
                    .totalUsers
            ) ?? 0
        case .pvpUtilization:
            return (
                try? pvpUtilizationDataFetchModelResult?.get().data
                    .totalUsers
            ) ?? 0
        }
    }

    var paramsDetailDescription: String {
        switch showingType {
        case .fullStarHoldingRate:
            return fullStarHoldingParam.detail()
        case .holdingRate:
            return holdingParam.detail()
        case .abyssAvatarsUtilization:
            return utilizationParams.detail()
        case .teamUtilization:
            return teamUtilizationParams.detail()
        case .pvpUtilization:
            return pvpUtilizationParams.detail()
        }
    }

    func getData() {
        switch showingType {
        case .abyssAvatarsUtilization:
            getUtilizationResult()
        case .holdingRate:
            getAvatarHoldingResult()
        case .fullStarHoldingRate:
            getFullStarHoldingResult()
        case .teamUtilization:
            getTeamUtilizationResult()
        case .pvpUtilization:
            getPVPUtilizationResult()
        }
    }

    // MARK: Private

    private func getAvatarHoldingResult() {
        API.PSAServer.fetchHoldingRateData(
            queryStartDate: holdingParam.date,
            server: holdingParam.server
        ) { result in
            withAnimation {
                self.avatarHoldingResult = result
            }
        }
    }

    private func getFullStarHoldingResult() {
        API.PSAServer.fetchFullStarHoldingRateData(
            season: fullStarHoldingParam.season,
            server: fullStarHoldingParam.server
        ) { result in
            withAnimation {
                self.fullStaAvatarHoldingResult = result
            }
        }
    }

    private func getUtilizationResult() {
        API.PSAServer.fetchAbyssUtilizationData(
            season: utilizationParams.season,
            server: utilizationParams.server,
            floor: utilizationParams.floor,
            pvp: false
        ) { result in
            withAnimation {
                self.utilizationDataFetchModelResult = result
            }
        }
    }

    private func getTeamUtilizationResult() {
        API.PSAServer.fetchTeamUtilizationData(
            season: teamUtilizationParams.season,
            server: teamUtilizationParams.server,
            floor: teamUtilizationParams.floor
        ) { result in
            self.teamUtilizationDataFetchModelResult = result
        }
    }

    private func getPVPUtilizationResult() {
        API.PSAServer.fetchAbyssUtilizationData(
            season: utilizationParams.season,
            server: utilizationParams.server,
            floor: utilizationParams.floor,
            pvp: true
        ) { result in
            withAnimation {
                self.pvpUtilizationDataFetchModelResult = result
            }
        }
    }
}

// MARK: - AbyssDataCollectionView

struct AbyssDataCollectionView: View {
    typealias IntervalDate = (
        month: Int?,
        day: Int?,
        hour: Int?,
        minute: Int?,
        second: Int?
    )

    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var abyssDataCollectionViewModel: AbyssDataCollectionViewModel =
        .init()

    @State
    var isWebSheetShow: Bool = false

    var body: some View {
        VStack {
            switch abyssDataCollectionViewModel.showingType {
            case .abyssAvatarsUtilization:
                ShowAvatarPercentageViewWithSection()
            case .pvpUtilization:
                if getRemainDays("2023-04-01 00:04:00")!.second! < 0 {
                    ShowAvatarPercentageViewWithSection()
                } else {
                    VStack {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.largeTitle)
                        Text("自2023年4月1日起提供")
                            .padding()
                            .font(.headline)
                    }
                }
            case .fullStarHoldingRate, .holdingRate:
                ShowAvatarPercentageView()
            case .teamUtilization:
                ShowTeamPercentageView()
            }
        }
        .onAppear {
            if viewModel.charLoc == nil || viewModel.charMap == nil {
                viewModel.refreshCharLocAndCharMap()
            }
        }
        .environmentObject(abyssDataCollectionViewModel)
        .listStyle(.insetGrouped)
        .hideTabBar()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isWebSheetShow = true
                } label: {
                    Image(systemName: "questionmark.circle")
                }
            }
            ToolbarItem(placement: .principal) {
                Menu {
                    ForEach(
                        AbyssDataCollectionViewModel.ShowingData.allCases,
                        id: \.rawValue
                    ) { choice in
                        Button(choice.rawValue.localized) {
                            withAnimation {
                                abyssDataCollectionViewModel
                                    .showingType = choice
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle")
                        Text(
                            abyssDataCollectionViewModel.showingType.rawValue
                                .localized
                        )
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                switch abyssDataCollectionViewModel.showingType {
                case .holdingRate:
                    AvatarHoldingParamsSettingBar(
                        params: $abyssDataCollectionViewModel
                            .holdingParam
                    )
                case .fullStarHoldingRate:
                    FullStarAvatarHoldingParamsSettingBar(
                        params: $abyssDataCollectionViewModel
                            .fullStarHoldingParam
                    )
                case .abyssAvatarsUtilization:
                    UtilizationParasSettingBar(
                        params: $abyssDataCollectionViewModel
                            .utilizationParams
                    )
                case .teamUtilization:
                    TeamUtilizationParasSettingBar(
                        params: $abyssDataCollectionViewModel
                            .teamUtilizationParams
                    )
                case .pvpUtilization:
                    UtilizationParasSettingBar(
                        pvp: true,
                        params: $abyssDataCollectionViewModel
                            .pvpUtilizationParams
                    )
                }
            }
        }
        .toolbarSavePhotoButtonInIOS16 {
            shareView()
        }
        .sheet(isPresented: $isWebSheetShow) {
            let url: String = {
                switch Bundle.main.preferredLocalizations.first?.prefix(2) {
                case "zh":
                    return "https://ophelper.top/static/faq_abyss.html"
                case "en":
                    return "https://ophelper.top/static/faq_abyss_en.html"
                case "ja":
                    return "https://ophelper.top/static/faq_abyss_ja.html"
                default:
                    return "https://ophelper.top/static/faq_abyss_en.html"
                }
            }()
            NavigationView {
                WebBroswerView(url: url)
                    .dismissableSheet(isSheetShow: $isWebSheetShow)
                    .navigationTitle("深渊统计榜单FAQ")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    @ViewBuilder
    func shareView() -> some View {
        if #available(iOS 16, *), let charMap = viewModel.charMap,
           let charLoc = viewModel.charLoc {
            VStack {
                Text(
                    abyssDataCollectionViewModel.showingType.rawValue
                        .localized
                )
                .font(.title)
                Group {
                    switch abyssDataCollectionViewModel.showingType {
                    case .holdingRate:
                        if let avatars = try? abyssDataCollectionViewModel
                            .avatarHoldingResult?.get().data.avatars {
                            ShowAvatarPercentageShare(
                                avatars: avatars,
                                charMap: charMap,
                                charLoc: charLoc
                            )
                        }

                    case .fullStarHoldingRate:
                        if let avatars = try? abyssDataCollectionViewModel
                            .fullStaAvatarHoldingResult?.get().data.avatars {
                            ShowAvatarPercentageShare(
                                avatars: avatars,
                                charMap: charMap,
                                charLoc: charLoc
                            )
                        }

                    case .abyssAvatarsUtilization:
                        if let avatars = try? abyssDataCollectionViewModel
                            .utilizationDataFetchModelResult?.get().data
                            .avatars {
                            ShowAvatarPercentageShare(
                                avatars: avatars
                                    .sorted(by: {
                                        $0.percentage ?? 0 > $1.percentage ?? 0
                                    }),
                                charMap: charMap,
                                charLoc: charLoc
                            )
                        }
                    case .pvpUtilization:
                        if let avatars = try? abyssDataCollectionViewModel
                            .pvpUtilizationDataFetchModelResult?.get().data
                            .avatars {
                            ShowAvatarPercentageShare(
                                avatars: avatars
                                    .sorted(by: {
                                        $0.percentage ?? 0 > $1.percentage ?? 0
                                    }),
                                charMap: charMap,
                                charLoc: charLoc
                            )
                        }
                    case .teamUtilization:
                        if let data = try? abyssDataCollectionViewModel
                            .teamUtilizationDataFetchModelResult?.get().data {
                            let teams: [TeamUtilizationData.Team] = {
                                switch abyssDataCollectionViewModel
                                    .teamUtilizationParams.half {
                                case .all:
                                    return data.teams
                                        .sorted(by: {
                                            $0.percentage > $1.percentage
                                        })
                                case .firstHalf:
                                    return data.teamsFH
                                        .sorted(by: {
                                            $0.percentage > $1.percentage
                                        })
                                case .secondHalf:
                                    return data.teamsSH
                                        .sorted(by: {
                                            $0.percentage > $1.percentage
                                        })
                                }
                            }()
                            ShowTeamPercentageShare(
                                teams: teams.prefix(32)
                                    .sorted(by: { $0.percentage > $1.percentage
                                    }),
                                charMap: charMap,
                                charLoc: charLoc
                            )
                        }
                    }
                }
                HStack {
                    let date: String = {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        formatter.timeStyle = .medium
                        return formatter.string(from: Date())
                    }()
                    Text(
                        "共统计\(abyssDataCollectionViewModel.totalDataCount)用户\(abyssDataCollectionViewModel.paramsDescription)\n\(abyssDataCollectionViewModel.paramsDetailDescription)·生成于\(date)"
                    )
                    .font(.footnote)
                    .minimumScaleFactor(0.5)
                    Spacer()
                    Image("AppIconHD")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text("原神披萨小助手").bold().font(.footnote)
                }
            }
            .padding()
        }
    }

    func getRemainDays(_ endAt: String) -> IntervalDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Server(
            rawValue: UserDefaults(suiteName: "group.GenshinPizzaHelper")?
                .string(forKey: "defaultServer") ?? Server.asia.rawValue
        )?.timeZone() ?? Server.asia.timeZone()
        let endDate = dateFormatter.date(from: endAt)
        guard let endDate = endDate else {
            return nil
        }
        let interval = endDate - Date()
        return interval
    }
}

// MARK: - ShowAvatarPercentageView

private struct ShowAvatarPercentageView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @EnvironmentObject
    var abyssDataCollectionViewModel: AbyssDataCollectionViewModel
    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var result: FetchHomeModelResult<AvatarPercentageModel>? {
        switch abyssDataCollectionViewModel.showingType {
        case .fullStarHoldingRate:
            return abyssDataCollectionViewModel.fullStaAvatarHoldingResult
        case .holdingRate:
            return abyssDataCollectionViewModel.avatarHoldingResult
        case .abyssAvatarsUtilization:
            return abyssDataCollectionViewModel.utilizationDataFetchModelResult
        case .pvpUtilization:
            return abyssDataCollectionViewModel
                .pvpUtilizationDataFetchModelResult
        default:
            return nil
        }
    }

    var body: some View {
        List {
            if let result = result {
                switch result {
                case let .success(data):
                    let data = data.data
                    Section {
                        ForEach(data.avatars.sorted(by: {
                            switch abyssDataCollectionViewModel.showingType {
                            case .abyssAvatarsUtilization, .pvpUtilization,
                                 .teamUtilization:
                                return ($0.percentage ?? 0) >
                                    ($1.percentage ?? 0)
                            case .fullStarHoldingRate, .holdingRate:
                                return $0.charId < $1.charId
                            }
                        }), id: \.charId) { avatar in
                            renderLine(avatar)
                        }
                    } header: {
                        Text(
                            "共统计\(data.totalUsers)用户\(abyssDataCollectionViewModel.paramsDescription)"
                        )
                        .textCase(.none)
                    }
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            } else {
                ProgressView()
            }
        }
    }

    func renderLine(_ avatar: AvatarPercentageModel.Avatar) -> some View {
        guard let char = viewModel.charMap?["\(avatar.charId)"] else {
            return AnyView(EmptyView())
        }
        let charName = char.i18nNameFixed(
            by: viewModel.charLoc,
            enkaID: avatar.charId
        )
        let result = HStack {
            Label {
                Text(charName.localizedWithFix)
            } icon: {
                char.decoratedIcon(30, cutTo: .face)
            }
            Spacer()
            Text(
                percentageFormatter
                    .string(from: (
                        avatar
                            .percentage ?? 0.0
                    ) as NSNumber)!
            )
        }
        return AnyView(result)
    }
}

// MARK: - ShowAvatarPercentageViewWithSection

private struct ShowAvatarPercentageViewWithSection: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @EnvironmentObject
    var abyssDataCollectionViewModel: AbyssDataCollectionViewModel
    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var result: FetchHomeModelResult<AvatarPercentageModel>? {
        switch abyssDataCollectionViewModel.showingType {
        case .fullStarHoldingRate:
            return abyssDataCollectionViewModel.fullStaAvatarHoldingResult
        case .holdingRate:
            return abyssDataCollectionViewModel.avatarHoldingResult
        case .abyssAvatarsUtilization:
            return abyssDataCollectionViewModel.utilizationDataFetchModelResult
        case .pvpUtilization:
            return abyssDataCollectionViewModel
                .pvpUtilizationDataFetchModelResult
        default:
            return nil
        }
    }

    var avatarSectionDatas: [[AvatarPercentageModel.Avatar]]? {
        switch abyssDataCollectionViewModel.showingType {
        case .abyssAvatarsUtilization:
            return getDataSection(
                data: abyssDataCollectionViewModel
                    .utilizationDataFetchModelResult
            )
        case .pvpUtilization:
            return getDataSection(
                data: abyssDataCollectionViewModel
                    .pvpUtilizationDataFetchModelResult
            )
        default:
            return getDataSection(
                data: abyssDataCollectionViewModel
                    .utilizationDataFetchModelResult
            )
        }
    }

    var body: some View {
        List {
            if let result = result,
               let avatarSectionDatas = avatarSectionDatas {
                switch result {
                case let .success(data):
                    let data = data.data
                    ForEach(0 ..< avatarSectionDatas.count, id: \.self) { i in
                        Section {
                            ForEach(
                                avatarSectionDatas[i],
                                id: \.charId
                            ) { avatar in
                                renderLine(avatar)
                            }
                        } header: {
                            VStack(alignment: .leading) {
                                if i == 0 {
                                    Text(
                                        "共统计\(data.totalUsers)用户\(abyssDataCollectionViewModel.paramsDescription)"
                                    )
                                    Text("使用率分级仅作深渊配队参考，不代表对角色的任何评价。")
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom, 5)
                                }
                                switch i {
                                case 0:
                                    Text("T\(i) ") + Text("强烈推荐选用的角色")
                                case 1:
                                    Text("T\(i) ") + Text("推荐选用的角色")
                                case 2:
                                    Text("T\(i) ") + Text("优先选用的角色")
                                case 3:
                                    Text("T\(i) ") + Text("普遍可用的角色")
                                case 4:
                                    Text("T\(i) ") + Text("可以选用的角色")
                                case 5:
                                    Text("T\(i) ") + Text("酌情选用的角色")
                                default:
                                    EmptyView()
                                }
                            }
                            .textCase(.none)
                        }
                    }
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            } else {
                ProgressView()
            }
        }
    }

    func renderLine(_ avatar: AvatarPercentageModel.Avatar) -> some View {
        guard let char = viewModel.charMap?["\(avatar.charId)"] else {
            return AnyView(EmptyView())
        }
        let charName = char.i18nNameFixed(
            by: viewModel.charLoc,
            enkaID: avatar.charId
        )
        let result = HStack {
            Label {
                Text(charName.localizedWithFix)
            } icon: {
                char.decoratedIcon(30, cutTo: .face)
            }
            Spacer()
            Text(
                percentageFormatter
                    .string(from: (
                        avatar
                            .percentage ?? 0.0
                    ) as NSNumber)!
            )
        }

        return AnyView(result)
    }

    func getDataSection(data: FetchHomeModelResult<AvatarPercentageModel>?)
        -> [[AvatarPercentageModel.Avatar]]? {
        guard let data = data else {
            return nil
        }
        switch data {
        case let .success(dataSuccess):
            let avatarsSrc = dataSuccess.data.avatars
            let avatars = avatarsSrc.sorted(by: {
                ($0.percentage ?? 0) > ($1.percentage ?? 0)
            })

            var sectionIndexes = [Int]()
            var gaps = [Int: Double]()
            guard !avatars.isEmpty else { return nil }
            for i in 0 ..< avatars.count - 1 {
                guard let percentage = avatars[i].percentage,
                      let percentage2 = avatars[i + 1].percentage else {
                    continue
                }
                if percentage > 0.05 {
                    gaps.updateValue(
                        (percentage - percentage2) *
                            (Double(i / avatars.count) * 8 + 1),
                        forKey: i
                    )
                }
            }
            let gapsSorted = gaps.sorted(by: {
                $0.value > $1.value
            })
            for item in gapsSorted {
                if item.value >= 0.07 * (avatars[item.key].percentage ?? 1.0) {
                    sectionIndexes.append(item.key)
                    if sectionIndexes.count > 4 {
                        break
                    }
                }
            }

            var resLists = [[AvatarPercentageModel.Avatar]]()
            var curList = [AvatarPercentageModel.Avatar]()
            for i in 0 ..< avatars.count {
                curList.append(avatars[i])
                if sectionIndexes.contains(i) {
                    resLists.append(curList)
                    curList.removeAll()
                }
            }
            resLists.append(curList)
            return resLists

        case .failure:
            return nil
        }
    }
}

// MARK: - ShowAvatarPercentageShare

@available(iOS 16.0, *)
private struct ShowAvatarPercentageShare: View {
    let avatars: [AvatarPercentageModel.Avatar]
    let charMap: [String: ENCharacterMap.Character]
    let charLoc: [String: String]

    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var eachColumnAvatars: [[AvatarPercentageModel.Avatar]] {
        let chunkSize = 16 // 每列的角色数
        return stride(from: 0, to: avatars.count, by: chunkSize).map {
            Array(avatars[$0 ..< min($0 + chunkSize, avatars.count)])
        }
    }

    var body: some View {
        HStack(alignment: .top) {
            ForEach(eachColumnAvatars, id: \.first!.charId) { avatars in
                Grid(alignment: .leading) {
                    ForEach(avatars, id: \.charId) { avatar in
                        renderLine(avatar)
                    }
                }
            }
        }
    }

    func renderLine(_ avatar: AvatarPercentageModel.Avatar) -> some View {
        guard let char = charMap["\(avatar.charId)"] else {
            return AnyView(EmptyView())
        }
        let charName = char.i18nNameFixed(by: charLoc, enkaID: avatar.charId)
        let result = GridRow {
            Label {
                Text(charName.localizedWithFix).fixedSize()
            } icon: {
                char.decoratedIcon(30, cutTo: .face)
            }
            Text(
                percentageFormatter
                    .string(from: (
                        avatar
                            .percentage ?? 0.0
                    ) as NSNumber)!
            )
            .fixedSize()
            .gridColumnAlignment(.trailing)
        }
        return AnyView(result)
    }
}

// MARK: - ShowTeamPercentageView

private struct ShowTeamPercentageView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @EnvironmentObject
    var abyssDataCollectionViewModel: AbyssDataCollectionViewModel
    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var result: TeamUtilizationDataFetchModelResult? {
        abyssDataCollectionViewModel.teamUtilizationDataFetchModelResult
    }

    var body: some View {
        List {
            if let result = result, let charMap = viewModel.charMap {
                switch result {
                case let .success(data):
                    let data = data.data
                    let teams: [TeamUtilizationData.Team] = {
                        switch abyssDataCollectionViewModel
                            .teamUtilizationParams.half {
                        case .all:
                            return data.teams
                        case .firstHalf:
                            return data.teamsFH
                        case .secondHalf:
                            return data.teamsSH
                        }
                    }()
                    Section {
                        let teams = teams
                            .sorted(by: { $0.percentage > $1.percentage })
                        ForEach(
                            Array(zip(teams.indices, teams)),
                            id: \.0
                        ) { index, team in
                            HStack {
                                ForEach(
                                    team.team.sorted(by: <),
                                    id: \.self
                                ) { avatarId in
                                    if let char = charMap["\(avatarId)"] {
                                        char.decoratedIcon(40, cutTo: .face)
                                    }
                                }
                                Spacer()

                                Text(
                                    percentageFormatter
                                        .string(from: (
                                            team
                                                .percentage
                                        ) as NSNumber)!
                                )
                                Image(systemName: "\(index + 1).circle")
                                    .font(.system(size: 14, weight: .light))
                            }
                        }
                    } header: {
                        Text(
                            "共统计\(data.totalUsers)用户\(abyssDataCollectionViewModel.paramsDescription)"
                        )
                        .textCase(.none)
                    }
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            } else {
                ProgressView()
            }
        }
    }
}

// MARK: - ShowTeamPercentageShare

private struct ShowTeamPercentageShare: View {
    let teams: [TeamUtilizationData.Team]
    let charMap: [String: ENCharacterMap.Character]
    let charLoc: [String: String]

    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var eachColumnTeams: [[(Int, TeamUtilizationData.Team)]] {
        let chunkSize = 16 // 每列的角色数
        let teams = teams.sorted(by: { $0.percentage > $1.percentage })
        let tuples = Array(zip(teams.indices, teams))
        return stride(from: 0, to: tuples.count, by: chunkSize).map {
            Array(tuples[$0 ..< min($0 + chunkSize, tuples.count)])
        }
    }

    var body: some View {
        HStack {
            ForEach(eachColumnTeams, id: \.first!.0) { teams in
                VStack {
                    ForEach(teams, id: \.0) { index, team in
                        HStack {
                            Image(systemName: "\(index + 1).circle")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.gray)
                            HStack {
                                ForEach(
                                    team.team.sorted(by: <),
                                    id: \.self
                                ) { avatarId in
                                    if let char = charMap["\(avatarId)"] {
                                        char.decoratedIcon(40, cutTo: .face)
                                    }
                                }
                            }
                            Text(
                                percentageFormatter
                                    .string(from: (
                                        team
                                            .percentage
                                    ) as NSNumber)!
                            )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - AvatarHoldingParamsSettingBar

private struct AvatarHoldingParamsSettingBar: View {
    @Binding
    var params: AvatarHoldingAPIParameters

    var body: some View {
        Menu {
            Button("所有服务器") { params.serverChoice = .all }
            ForEach(Server.allCases, id: \.rawValue) { server in
                Button("\(server.rawValue)") {
                    params.serverChoice = .server(server)
                }
            }
        } label: {
            Text(params.serverChoice.describe())
        }
        Spacer()
        DatePicker("", selection: $params.date, displayedComponents: [.date])
    }
}

// MARK: - AvatarHoldingAPIParameters

struct AvatarHoldingAPIParameters {
    var date: Date = Calendar.current.date(
        byAdding: .day,
        value: -30,
        to: Date()
    )!
    var serverChoice: ServerChoice = .all

    var server: Server? {
        switch serverChoice {
        case .all:
            return nil
        case let .server(server):
            return server
        }
    }

    func describe() -> String {
        let dateString: String = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }()
        return String(
            format: NSLocalizedString("·仅自%@后提交的数据", comment: ""),
            dateString
        )
    }

    func detail() -> String {
        "\(serverChoice.describe())"
    }
}

// MARK: - FullStarAvatarHoldingParamsSettingBar

private struct FullStarAvatarHoldingParamsSettingBar: View {
    @Binding
    var params: FullStarAPIParameters

    var body: some View {
        Menu {
            Button("所有服务器") { params.serverChoice = .all }
            ForEach(Server.allCases, id: \.rawValue) { server in
                Button("\(server.rawValue)") {
                    params.serverChoice = .server(server)
                }
            }
        } label: {
            Text(params.serverChoice.describe())
        }
        Spacer()
        Menu {
            ForEach(AbyssSeason.choices(), id: \.hashValue) { season in
                Button("\(season.describe())") { params.season = season }
            }
        } label: {
            Text(params.season.describe())
        }
    }
}

// MARK: - FullStarAPIParameters

struct FullStarAPIParameters {
    var season: AbyssSeason = .now()
    var serverChoice: ServerChoice = .all

    var server: Server? {
        switch serverChoice {
        case .all:
            return nil
        case let .server(server):
            return server
        }
    }

    func describe() -> String {
        ""
    }

    func detail() -> String {
        "\(serverChoice.describe())·\(season.describe())"
    }
}

// MARK: - UtilizationParasSettingBar

private struct UtilizationParasSettingBar: View {
    var pvp: Bool = false
    @Binding
    var params: UtilizationAPIParameters

    var body: some View {
        Menu {
            Button("所有服务器") { params.serverChoice = .all }
            ForEach(Server.allCases, id: \.rawValue) { server in
                Button("\(server.rawValue)") {
                    params.serverChoice = .server(server)
                }
            }
        } label: {
            Text(params.serverChoice.describe())
        }
        Spacer()
        Menu {
            ForEach((9 ... 12).reversed(), id: \.self) { number in
                Button("\(number)层") {
                    params.floor = number
                }
            }
        } label: {
            Text("\(params.floor)层")
        }
        Spacer()
        Menu {
            ForEach(AbyssSeason.choices(pvp: pvp), id: \.hashValue) { season in
                Button("\(season.describe())") { params.season = season }
            }
        } label: {
            Text(params.season.describe())
        }
    }
}

// MARK: - UtilizationAPIParameters

struct UtilizationAPIParameters {
    var season: AbyssSeason = .from(Date())
    var serverChoice: ServerChoice = .all

    var floor: Int = 12

    var server: Server? {
        switch serverChoice {
        case .all:
            return nil
        case let .server(server):
            return server
        }
    }

    func describe() -> String {
        "·仅包含满星玩家·计算方法：角色使用人数/角色拥有人数".localized
    }

    func detail() -> String {
        String(
            format: NSLocalizedString("%@·%@·%lld层", comment: "detail"),
            serverChoice.describe(),
            season.describe(),
            floor
        )
    }
}

// MARK: - TeamUtilizationParasSettingBar

private struct TeamUtilizationParasSettingBar: View {
    @Binding
    var params: TeamUtilizationAPIParameters

    var body: some View {
        Menu {
            Button("所有服务器") { params.serverChoice = .all }
            ForEach(Server.allCases, id: \.rawValue) { server in
                Button("\(server.rawValue)") {
                    params.serverChoice = .server(server)
                }
            }
        } label: {
            Text(params.serverChoice.describe())
        }
        Spacer()
        Menu {
            ForEach((9 ... 12).reversed(), id: \.self) { number in
                Button("\(number)层") {
                    params.floor = number
                }
            }
        } label: {
            Text("\(params.floor)层")
        }
        Spacer()
        Menu {
            ForEach(AbyssSeason.choices(), id: \.hashValue) { season in
                Button("\(season.describe())") { params.season = season }
            }
        } label: {
            Text(params.season.describe())
        }
        Spacer()
        Menu {
            ForEach(
                TeamUtilizationAPIParameters.Half.allCases,
                id: \.rawValue
            ) { half in
                Button("\(half.rawValue.localized)") {
                    withAnimation {
                        params.half = half
                    }
                }
            }
        } label: {
            Text(params.half.rawValue.localized)
        }
    }
}

// MARK: - TeamUtilizationAPIParameters

struct TeamUtilizationAPIParameters {
    enum Half: String, CaseIterable {
        case all = "整层"
        case secondHalf = "下半"
        case firstHalf = "上半"
    }

    var season: AbyssSeason = .from(Date())
    var serverChoice: ServerChoice = .all

    var floor: Int = 12

    var half: Half = .all

    var server: Server? {
        switch serverChoice {
        case .all:
            return nil
        case let .server(server):
            return server
        }
    }

    func describe() -> String {
        "·仅包含满星玩家·包含旅行者的队伍已合并".localized
    }

    func detail() -> String {
        String(
            format: NSLocalizedString("%@·%@·%lld层·%@", comment: "detail"),
            serverChoice.describe(),
            season.describe(),
            floor,
            half.rawValue.localized
        )
    }
}

typealias AbyssSeason = Int
extension AbyssSeason {
    fileprivate static func from(_ date: Date) -> Self {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let yearMonth = Int(dateFormatter.string(from: date))! * 10
        if Calendar.current.component(.day, from: date) > 15 {
            return yearMonth + 1
        } else {
            return yearMonth
        }
    }

    fileprivate static func now() -> Self {
        from(Date())
    }

    fileprivate var startDateOfSeason: Date {
        let seasonString = String(self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        let yearMonth = formatter.date(from: String(seasonString.prefix(6)))!
        let year = Calendar.current.component(.year, from: yearMonth)
        let month = Calendar.current.component(.month, from: yearMonth)
        let day = {
            if String(seasonString.suffix(1)) == "0" {
                return 1
            } else {
                return 16
            }
        }()
        return Calendar.current
            .date(from: DateComponents(year: year, month: month, day: day))!
    }

    fileprivate func describe() -> String {
        let seasonString = String(self)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMM"
//        let yearMonth = formatter.date(from: String(seasonString.prefix(6)))!
//        let year = Calendar.current.component(.year, from: yearMonth)
//        let month = Calendar.current.component(.month, from: yearMonth)
        let half = {
            if String(seasonString.suffix(1)) == "0" {
                return "上".localized
            } else {
                return "下".localized
            }
        }()
        let yearStr = String(seasonString.prefix(6).prefix(4))
        guard let monthNum = Int(seasonString.prefix(6).suffix(2)) else {
            return ""
        }
        let monthStr = String(describing: monthNum)
        return yearStr + " " + monthStr + "月".localized + half
    }

    fileprivate static func choices(
        pvp: Bool = false,
        from date: Date = Date()
    ) -> [AbyssSeason] {
        var choices = [Self]()
        var date = date
        var startDate = Calendar.current
            .date(from: DateComponents(year: 2022, month: 11, day: 1))!
        if pvp {
            startDate = Calendar.current
                .date(from: DateComponents(year: 2023, month: 4, day: 1))!
        }
        // 以下仅判断本月
        if Calendar.current.dateComponents([.day], from: date).day! >= 16 {
            choices.append(date.yyyyMM() * 10 + 1)
        }
        choices.append(date.yyyyMM() * 10)
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        while date >= startDate {
            choices.append(date.yyyyMM() * 10 + 1)
            choices.append(date.yyyyMM() * 10)
            date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        }
        return choices
    }
}

// MARK: - ServerChoice

enum ServerChoice {
    case all
    case server(Server)

    // MARK: Internal

    func describe() -> String {
        switch self {
        case .all:
            return "所有服务器".localized
        case let .server(server):
            return server.rawValue
        }
    }
}

extension Date {
    fileprivate func yyyyMM() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        return Int(formatter.string(from: self))!
    }
}
