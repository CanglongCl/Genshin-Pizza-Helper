//
//  GachaView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/28.
//

import Charts
import CoreData
import HBMihoyoAPI
import SwiftUI

// MARK: - GachaView

struct GachaView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    @State
    var showTime: Bool = false

    @State
    var isHelpSheetShow: Bool = false

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                mainView()
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Menu {
                                ForEach(
                                    GachaType
                                        .allAvaliableGachaType()
                                ) { gachaType in
                                    Button(gachaType.localizedDescription()) {
                                        withAnimation {
                                            gachaViewModel.filter
                                                .gachaType = gachaType
                                        }
                                    }
                                }
                            } label: {
                                Text(
                                    gachaViewModel.filter.gachaType
                                        .localizedDescription()
                                )
                            }
                        }
                    }
            } else {
                mainView()
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            FilterEditer(
                                filter: $gachaViewModel.filter,
                                showTime: $showTime
                            )
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                GetGachaNavigationMenu(
                    showByAPI: viewModel.accounts
                        .first(where: { $0.config.server.region == .cn }) !=
                        nil,
                    isHelpSheetShow: $isHelpSheetShow
                )
            }

            ToolbarItem(placement: .principal) {
                Menu {
                    ForEach(
                        gachaViewModel.allAvaliableAccountUID,
                        id: \.self
                    ) { uid in
                        Group {
                            if let name: String = viewModel.accounts
                                .first(where: { $0.config.uid == uid })?.config
                                .name {
                                Button(name) {
                                    gachaViewModel.filter.uid = uid
                                }
                            } else {
                                Button(uid) {
                                    gachaViewModel.filter.uid = uid
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle")
                        if let uid: String = gachaViewModel.filter.uid {
                            if let name: String = viewModel.accounts
                                .first(where: { $0.config.uid == uid })?.config
                                .name {
                                Text(name)
                            } else {
                                Text(uid)
                            }
                        } else {
                            Text("请点击右上角获取抽卡记录")
                        }
                    }
                }
                .disabled(gachaViewModel.allAvaliableAccountUID.isEmpty)
            }
        }
        .environmentObject(gachaViewModel)
        .hideTabBar()
    }

    @ViewBuilder
    func mainView() -> some View {
        List {
            if !gachaViewModel.filteredGachaItemsWithCount.isEmpty {
                if #available(iOS 16.0, *) {
                    Section {
                        GachaChart(
                            items: gachaViewModel
                                .filteredGachaItemsWithCount
                        )
                        NavigationLink {
                            GachaChartView()
                                .environmentObject(gachaViewModel)
                        } label: {
                            Label("更多图表", systemImage: "chart.bar.xaxis")
                        }
                    }
                }
                GachaStatisticSectionView()
            } else {
                Text("暂无五星祈愿记录").foregroundColor(.gray)
            }
            if #available(iOS 16.0, *) {
                Section {
                    NavigationLink("详细记录") {
                        GachaDetailView()
                    }
                }
            } else {
                Section {
                    ForEach(
                        gachaViewModel.filteredGachaItemsWithCount,
                        id: \.0.id
                    ) { item, count in
                        VStack(spacing: 1) {
                            GachaItemBar(
                                item: item,
                                count: count,
                                showTime: showTime,
                                showingType: gachaViewModel.filter.rank
                            )
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isHelpSheetShow, content: {
            HelpSheet(isShow: $isHelpSheetShow)
        })
    }
}

// MARK: - GachaStatisticSectionView

private struct GachaStatisticSectionView: View {
    // MARK: Internal

    enum Rank: Int, CaseIterable {
        case one
        case two
        case three
        case four
        case five
    }

    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    var body: some View {
        let items = gachaViewModel.sortedAndFilteredGachaItem
        let fiveStarItemsWithCount = gachaViewModel
            .filteredGachaItemsWithCount
            .filter { item, _ in
                item.rankType == .five
            }
        let fiveStars = items.filter { item in
            item.rankType == .five
        }
        let fiveStarsNotLose = fiveStars.filter { item in
            !item.isLose5050()
        }
        let limitedNumber = fiveStarItemsWithCount
            .map(\.count)
            .reduce(0, +) /
            max(
                fiveStarItemsWithCount
                    .filter { item, _ in
                        !item.isLose5050()
                    }.count,
                1
            )
        Section {
            HStack {
                Label("当前已垫", systemImage: "flag.fill")
                Spacer()
                Text(
                    "\(gachaViewModel.sortedAndFilteredGachaItem.firstIndex(where: { $0.rankType == .five }) ?? gachaViewModel.sortedAndFilteredGachaItem.count)抽"
                )
            }
            HStack {
                Label(
                    showDrawingNumber ? "总抽数" : "总消耗原石数",
                    systemImage: "hand.tap.fill"
                )
                Spacer()
                let total = gachaViewModel.sortedAndFilteredGachaItem
                    .filter { item in
                        item.gachaType == gachaViewModel.filter
                            .gachaType
                    }.count
                Text("\(showDrawingNumber ? total : total * 160)")
            }
            HStack {
                Label(
                    showDrawingNumber ? "五星平均抽数" : "五星平均消耗原石数",
                    systemImage: "star"
                )
                Spacer()
                let number = fiveStarItemsWithCount.map { $0.count }
                    .reduce(0) { $0 + $1 } /
                    max(fiveStarItemsWithCount.count, 1)
                Text("\(showDrawingNumber ? number : number * 160)")
            }
            if gachaViewModel.filter.gachaType != .standard {
                HStack {
                    Label(
                        showDrawingNumber ? "限定五星平均抽数" : "限定五星平均消耗原石数",
                        systemImage: "star.fill"
                    )
                    Spacer()
                    Text(
                        "\(showDrawingNumber ? limitedNumber : limitedNumber * 160)"
                    )
                }
                HStack {
                    let fmt: NumberFormatter = {
                        let fmt = NumberFormatter()
                        fmt.maximumFractionDigits = 2
                        fmt.numberStyle = .percent
                        return fmt
                    }()
                    // 如果获得的第一个五星是限定，默认其不歪
                    let pct = 1.0 -
                        Double(
                            fiveStars.count - fiveStarsNotLose
                                .count // 歪次数 = 非限定五星数量
                        ) /
                        Double(
                            fiveStarsNotLose
                                .count +
                                ((fiveStars.last?.isLose5050() ?? false) ? 1 : 0)
                        ) // 小保底次数 = 限定五星数量（如果抽的第一个是非限定，则多一次小保底）
                    Label("不歪率", systemImage: "chart.pie.fill")
                    Spacer()
                    Text(
                        "\(fmt.string(from: pct as NSNumber)!)"
                    )
                }
            }
            if gachaViewModel.filter.gachaType != .standard {
                VStack {
                    HStack {
                        Text("派蒙的评价")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        let judgedRank = Rank.judge(
                            limitedDrawNumber: limitedNumber,
                            gachaType: gachaViewModel.filter.gachaType
                        )
                        ForEach(Rank.allCases, id: \.rawValue) { rank in
                            Group {
                                if judgedRank == rank {
                                    rank.image().resizable()
                                        .scaledToFit()
                                } else {
                                    rank.image().resizable()
                                        .scaledToFit()
                                        .opacity(0.25)
                                }
                            }
                            .frame(width: 50, height: 50)
                            Spacer()
                        }
                    }
                }
            }
        } header: {
            Text("统计数据")
                .textCase(.none)
        }
        .onTapGesture {
            simpleTaptic(type: .light)
            if gachaViewModel.filter.gachaType != .standard {
                withAnimation(.easeInOut(duration: 0.1)) {
                    showDrawingNumber.toggle()
                }
            }
        }
        .onReceive(gachaViewModel.objectWillChange) {
            if gachaViewModel.filter.gachaType == .standard {
                showDrawingNumber = true
            }
        }
    }

    // MARK: Private

    /// 展示原石或抽数
    @State
    private var showDrawingNumber: Bool = true
}

extension GachaStatisticSectionView.Rank {
    func image() -> Image {
        switch self {
        case .one:
            return Image("UI_EmotionIcon5")
        case .two:
            return Image("UI_EmotionIcon4")
        case .three:
            return Image("UI_EmotionIcon6")
        case .four:
            return Image("UI_EmotionIcon2")
        case .five:
            return Image("UI_EmotionIcon1")
        }
    }

    fileprivate static func judge(
        limitedDrawNumber: Int,
        gachaType: GachaType
    )
        -> Self {
        switch gachaType {
        case .character:
            switch limitedDrawNumber {
            case ...80:
                return .five
            case 80 ..< 90:
                return .four
            case 90 ..< 100:
                return .three
            case 100 ..< 110:
                return .two
            case 110...:
                return .one
            default:
                return .one
            }
        case .weapon:
            switch limitedDrawNumber {
            case ...80:
                return .five
            case 80 ..< 90:
                return .four
            case 90 ..< 100:
                return .three
            case 100 ..< 110:
                return .two
            case 110...:
                return .one
            default:
                return .one
            }
        default:
            return .one
        }
    }
}

// MARK: - FilterEditer

private struct FilterEditer: View {
    @Binding
    var filter: GachaFilter
    @Binding
    var showTime: Bool

    var body: some View {
        Menu {
            ForEach(GachaType.allAvaliableGachaType()) { gachaType in
                Button(gachaType.localizedDescription()) {
                    withAnimation {
                        filter.gachaType = gachaType
                    }
                }
            }
        } label: {
            Text(filter.gachaType.localizedDescription())
        }
        Spacer()
        Button {
            withAnimation {
                showTime.toggle()
            }
        } label: {
            Image(
                systemName: showTime ? "calendar.circle.fill" :
                    "calendar.circle"
            )
        }
        Spacer()
        Menu {
            ForEach(GachaFilter.Rank.allCases) { rank in
                Button(rank.description) {
                    withAnimation {
                        filter.rank = rank
                    }
                }
            }
        } label: {
            Text(filter.rank.description)
        }
    }
}

// MARK: - GachaItemBar

private struct GachaItemBar: View {
    let item: GachaItem
    let count: Int
    let showTime: Bool
    let showingType: GachaFilter.Rank

    var width: CGFloat { showingType == .five ? 35 : 30 }
    var body: some View {
        HStack {
            Label {
                Text(item.localizedName)
            } icon: {
                item.decoratedIconView(width, cutTo: .face)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 1) {
                if (count != 1) || (item.rankType != .three) {
                    Text("\(count)")
                        .font(!showTime ? .body : .caption)
                }
                if showTime {
                    Text(item.formattedTime)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - GachaChart

@available(iOS 16.0, *)
private struct GachaChart: View {
    let items: [(GachaItem, count: Int)]

    var fiveStarItems: [(GachaItem, count: Int)] {
        items.filter { $0.0.rankType == .five }
    }

    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                ForEach(fiveStarItems, id: \.0.id) { item in
                    BarMark(
                        x: .value("角色", item.0.id),
                        y: .value("抽数", item.count)
                    )
                    .annotation(position: .top) {
                        Text("\(item.count)").foregroundColor(.gray)
                            .font(.caption)
                    }
                    .foregroundStyle(by: .value("抽数", item.0.id))
                }
                if !fiveStarItems.isEmpty {
                    RuleMark(y: .value(
                        "平均",
                        fiveStarItems.map { $0.count }
                            .reduce(0) { $0 + $1 } / max(fiveStarItems.count, 1)
                    ))
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                }
            }
            .chartXAxis(content: {
                AxisMarks { value in
                    AxisValueLabel(content: {
                        if let id = value.as(String.self),
                           let item = fiveStarItems
                           .first(where: { $0.0.id == id })?.0 {
                            VStack {
                                item.decoratedIconView(30, cutTo: .face)
                            }

                        } else {
                            EmptyView()
                        }
                    })
                }
            })
            .chartLegend(position: .top)
            .chartYAxis(content: {
                AxisMarks(position: .leading)
            })
            .chartForegroundStyleScale(range: colors)
            .chartLegend(.hidden)
            .frame(width: CGFloat(fiveStarItems.count * 50))
            .padding(.top)
            .padding(.bottom, 5)
            .padding(.leading, 1)
        }
    }

    var colors: [Color] {
        fiveStarItems.map { _, count in
            switch count {
            case 0 ..< 60:
                return .green
            case 60 ..< 80:
                return .yellow
            default:
                return .red
            }
        }
    }
}

// MARK: - GetGachaNavigationMenu

private struct GetGachaNavigationMenu: View {
    // MARK: Internal

    let showByAPI: Bool

    @Binding
    var isHelpSheetShow: Bool

    var body: some View {
        Menu {
            Button {
                isHelpSheetShow.toggle()
            } label: {
                Label("我该选哪个？", systemImage: "questionmark.bubble")
            }

            if showByAPI {
                Button {
                    showView1.toggle()
                } label: {
                    Label("通过API获取", systemImage: "network")
                }
            }
            #if canImport(GachaMIMTServer)
            Button {
                showView2.toggle()
            } label: {
                Label(
                    "通过抓包获取",
                    systemImage: "rectangle.and.text.magnifyingglass"
                )
            }
            #endif
            Button {
                showView3.toggle()
            } label: {
                Label("通过粘贴祈愿页面URL获取", systemImage: "list.bullet.clipboard")
            }
            Button {
                showView4.toggle()
            } label: {
                Label(
                    "导入UIGF祈愿记录",
                    systemImage: "square.and.arrow.down.on.square"
                )
            }
        } label: {
            Image(systemName: "goforward.plus")
        }
        .background(
            Group {
                NavigationLink(
                    destination: GetGachaView(),
                    isActive: $showView1
                ) {
                    EmptyView()
                }
                #if canImport(GachaMIMTServer)
                NavigationLink(
                    destination: MIMTGetGachaView(),
                    isActive: $showView2
                ) {
                    EmptyView()
                }
                #endif
                NavigationLink(
                    destination: GetGachaClipboardView(),
                    isActive: $showView3
                ) {
                    EmptyView()
                }
                NavigationLink(
                    destination: ImportGachaView(),
                    isActive: $showView4
                ) {
                    EmptyView()
                }
            }
        )
    }

    // MARK: Private

    @State
    private var showView1 = false
    @State
    private var showView2 = false
    @State
    private var showView3 = false
    @State
    private var showView4 = false
}

// MARK: - HelpSheet

private struct HelpSheet: View {
    @Binding
    var isShow: Bool

    var body: some View {
        NavigationView {
            List {
                Section {
                    Label(
                        "无论选择哪种方式，我们都为您提供了详细的操作教程",
                        systemImage: "person.fill.questionmark"
                    )
                    // TODO: not completed gacha tutorial video
//                    Label(
//                        "您也可以选择参考我们的视频完成相关操作",
//                        systemImage: "hand.thumbsup.fill"
//                    )
//                    GachaHelpVideoLink()
                }
                Section {
                    Label("如果您的帐号所在服务器位于中国大陆", systemImage: "text.bubble")
                    Label("请优先选择「通过API」一键获取", systemImage: "network")
                } footer: {
                    Text("仅适用于中国大陆服务器")
                        .bold()
                }
                Section {
                    Label("如果当前这台设备有安装《原神》", systemImage: "text.bubble")
                    Label(
                        "建议优先选择「通过抓包获取」",
                        systemImage: "rectangle.and.text.magnifyingglass"
                    )
                } footer: {
                    Text("适用于所有服务器")
                }
                Section {
                    Label("如果当前这台设备尚未安装《原神》", systemImage: "text.bubble")
                    Label(
                        "建议使用「通过粘贴祈愿页面URL」获取，我们亦内附了教程",
                        systemImage: "list.bullet.clipboard"
                    )
                } footer: {
                    Text("适用于所有服务器")
                }
                Section {
                    Label(
                        "如果您之前使用其他软件获取过祈愿记录，且该软件支持导出UIGF（统一可交换祈愿记录标准）格式的文件，您可以将其导入",
                        systemImage: "square.and.arrow.down.on.square"
                    )
                    if Bundle.main.preferredLocalizations.first?.prefix(2) == "zh" {
                        Link(
                            destination: URL(
                                string: "https://uigf.org/zh/partnership.html"
                            )!
                        ) {
                            Label(
                                "支持UIGF的软件",
                                systemImage: "app.badge.checkmark"
                            )
                        }
                    } else {
                        Link(
                            destination: URL(
                                string: "https://uigf.org/en/partnership.html"
                            )!
                        ) {
                            Label(
                                "支持UIGF的软件",
                                systemImage: "app.badge.checkmark"
                            )
                        }
                    }
                } footer: {
                    Text("适用于所有服务器")
                }
            }
            .navigationTitle("抽卡记录获取帮助")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        isShow.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - GachaHelpVideoLink

private struct GachaHelpVideoLink: View {
    var body: some View {
        Link(destination: URL(
            string: "https://www.bilibili.com/video/BV1Lg411S7wa"
        )!) {
            Label {
                Text("打开Bilibili观看")
            } icon: {
                Image("bilibili")
                    .resizable()
                    .foregroundColor(.blue)
                    .scaledToFit()
            }
        }
        Link(
            destination: URL(
                string: "https://www.youtube.com/watch?v=k9G2N8XYFm4"
            )!
        ) {
            Label {
                Text("打开YouTube观看")
            } icon: {
                Image("youtube")
                    .resizable()
                    .foregroundColor(.blue)
                    .scaledToFit()
            }
        }
    }
}

extension GachaItem {
    /// 是否歪了
    func isLose5050() -> Bool {
        guard gachaType != .standard else { return false }
        guard ![
            "阿莫斯之弓",
            "天空之翼",
            "四风原典",
            "天空之卷",
            "和璞鸢",
            "天空之脊",
            "狼的末路",
            "天空之傲",
            "风鹰剑",
            "天空之刃",
            "迪卢克",
            "琴",
            "七七",
            "莫娜"
        ].contains(name) else {
            return true
        }
        let calendar = Calendar(identifier: .gregorian)
        if name == "刻晴",
           !(
               calendar.date(
                   from: DateComponents(year: 2021, month: 2, day: 17)
               )! ... calendar.date(from: DateComponents(
                   year: 2021,
                   month: 3,
                   day: 2
               ))!
           ).contains(time) {
            return true
        } else if name == "提纳里",
                  !(
                      calendar
                          .date(
                              from: DateComponents(
                                  year: 2022,
                                  month: 8,
                                  day: 24
                              )
                          )! ... calendar.date(from: DateComponents(
                              year: 2022,
                              month: 9,
                              day: 9
                          ))!
                  ).contains(time) {
            return true
        } else if name == "迪希雅",
                  !(
                      calendar
                          .date(
                              from: DateComponents(year: 2023, month: 3, day: 1)
                          )! ... calendar.date(from: DateComponents(
                              year: 2023,
                              month: 3,
                              day: 21
                          ))!
                  ).contains(time) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - GachaDetailView

private struct GachaDetailView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    @State
    var showTime: Bool = false

    var body: some View {
        List {
            ForEach(
                gachaViewModel.filteredGachaItemsWithCount,
                id: \.0.id
            ) { item, count in
                VStack(spacing: 1) {
                    GachaItemBar(
                        item: item,
                        count: count,
                        showTime: showTime,
                        showingType: gachaViewModel.filter.rank
                    )
                }
            }
        }
        .navigationTitle("抽取记录")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                FilterEditer(
                    filter: $gachaViewModel.filter,
                    showTime: $showTime
                )
            }
            ToolbarItem(placement: .principal) {
                Menu {
                    ForEach(
                        gachaViewModel.allAvaliableAccountUID,
                        id: \.self
                    ) { uid in
                        Group {
                            if let name: String = viewModel.accounts
                                .first(where: { $0.config.uid == uid })?.config
                                .name {
                                Button(name) {
                                    gachaViewModel.filter.uid = uid
                                }
                            } else {
                                Button(uid) {
                                    gachaViewModel.filter.uid = uid
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle")
                        if let uid: String = gachaViewModel.filter.uid {
                            if let name: String = viewModel.accounts
                                .first(where: { $0.config.uid == uid })?.config
                                .name {
                                Text(name)
                            } else {
                                Text(uid)
                            }
                        } else {
                            Text("请点击右上角获取抽卡记录")
                        }
                    }
                }
                .disabled(gachaViewModel.allAvaliableAccountUID.isEmpty)
            }
        }
    }
}
