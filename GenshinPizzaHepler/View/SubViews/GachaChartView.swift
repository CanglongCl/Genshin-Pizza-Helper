//
//  GachaChartView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/29.
//

import Charts
import SwiftUI

// MARK: - GachaChartView

@available(iOS 16.0, *)
struct GachaChartView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @EnvironmentObject
    var gachaViewModel: GachaViewModel

    var body: some View {
        List {
//            NavigationLink {
//                List {
//                    Section {
//                        ForEach(
//                            [
//                                GachaType.character,
//                                GachaType.weapon,
//                                GachaType.standard,
//                            ],
//                            id: \.rawValue
//                        ) { type in
//                            VStack(alignment: .trailing, spacing: 0) {
//                                Text(type.localizedDescription()).font(.caption)
//                                    .foregroundColor(.gray)
//                                GachaTimeChart(
//                                    gachaViewModel: gachaViewModel,
//                                    type: type
//                                )
//                            }
//                        }
//                    } header: {
//                        Text("总抽数分布")
//                    }
//                    .navigationTitle("其他图表")
//                }
//            } label: {
//                Label(
//                    "其他图表",
//                    systemImage: "chart.bar.doc.horizontal"
//                )
//            }
            Section {
                GachaItemChart(
                    items: gachaViewModel
                        .filteredGachaItemsWithCount
                )
                .environmentObject(gachaViewModel)
            } header: {
                HStack {
                    Text(
                        gachaViewModel.filter.gachaType.localizedDescription()
                    )
                    Spacer()
                    Button(
                        "切换为\(gachaViewModel.filter.gachaType.nextOne().localizedDescription())"
                    ) {
                        withAnimation {
                            gachaViewModel.filter.gachaType = gachaViewModel
                                .filter.gachaType.nextOne()
                        }
                    }
                    .font(.caption)
                }
                .textCase(.none)
            }
        }
        .toolbar {
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

extension GachaType {
    fileprivate func nextOne() -> Self {
        switch self {
        case .character:
            return .weapon
        case .weapon:
            return .standard
        case .standard:
            return .character
        default:
            return .character
        }
    }
}

// MARK: - GachaItemChart

@available(iOS 16.0, *)
private struct GachaItemChart: View {
    let items: [(GachaItem, count: Int)]

    var fiveStarItems: [(GachaItem, count: Int)] {
        items.filter { $0.0.rankType == .five }
    }

    var averagePullsCount: Int {
        fiveStarItems.map(\.count).reduce(0, +) / max(fiveStarItems.count, 1)
    }

    var body: some View {
//        subChart(items: fiveStarItems.chunked(into: 60)[1])
        VStack(spacing: -12) {
            ForEach(fiveStarItems.chunked(into: 60), id: \.first!.0.id) { items in
                let isFirst = fiveStarItems.first!.0.id == items.first!.0.id
                let isLast = fiveStarItems.last!.0.id == items.last!.0.id
                if isFirst {
                    subChart(items: items, isFirst: isFirst, isLast: isLast).padding(.top)
                } else {
                    subChart(items: items, isFirst: isFirst, isLast: isLast)
                }
            }
        }
    }

    func matchedItems(with value: String) -> [GachaItem] {
        items.map(\.0).filter { $0.id == value }
    }

    func colors(items: [(GachaItem, count: Int)]) -> [Color] {
        fiveStarItems.map { _, count in
            switch count {
            case 0 ..< 62:
                return .green
            case 62 ..< 80:
                return .yellow
            default:
                return .red
            }
        }
    }

    @ViewBuilder
    func subChart(items: [(GachaItem, count: Int)], isFirst: Bool, isLast: Bool) -> some View {
        Chart {
            ForEach(items, id: \.0.id) { item in
                BarMark(
                    x: .value("抽数", item.count),
                    y: .value("角色", item.0.id),
                    width: 20
                )
                .annotation(position: .trailing) {
                    HStack(spacing: 3) {
                        let frame: CGFloat = 35
                        Text("\(item.count)").foregroundColor(.gray)
                            .font(.caption)
                        if item.0.isLose5050() {
                            Image("UI_EmotionIcon5").resizable().scaledToFit()
                                .frame(width: frame, height: frame)
                                .offset(y: -5)
                        } else {
                            EmptyView()
                        }
                    }
                }
                .foregroundStyle(by: .value("抽数", item.0.id))
            }
            if !fiveStarItems.isEmpty {
                RuleMark(x: .value(
                    "平均",
                    fiveStarItems.map { $0.count }
                        .reduce(0, +) / max(fiveStarItems.count, 1)
                ))
                .foregroundStyle(.gray)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                .annotation(alignment: .topLeading) {
                    if isFirst {
                        Text(
                            "平均抽数："
                                .localized + averagePullsCount.description
                        )
                        .font(.caption).foregroundColor(.gray)
                    }
                }
            }
        }
        .chartYAxis(content: {
            AxisMarks(preset: .aligned, position: .leading) { value in
                AxisValueLabel(content: {
                    if let id = value.as(String.self),
                       let item = items
                       .first(where: { $0.0.id == id })?.0 {
                        item.decoratedIconView(45, cutTo: .head)
                    } else {
                        EmptyView()
                    }
                })
            }
            AxisMarks { value in
                AxisValueLabel(content: {
                    if let theValue = value.as(String.self),
                       let item = matchedItems(with: theValue).first {
                        Text(item.localizedName)
                            .offset(y: items.count == 1 ? 0 : 8)
                    } else {
                        EmptyView()
                    }
                })
            }
        })
        .chartXAxis(content: {
            AxisMarks(values: [0, 25, 50, 75, 100]) { _ in
                AxisGridLine()
                if isLast {
                    AxisValueLabel()
                } else {
                    AxisValueLabel {
                        EmptyView()
                    }
                }
            }
        })
        .chartXScale(domain: 0 ... 110)
        .frame(height: CGFloat(items.count * 65))
        .chartForegroundStyleScale(range: colors(items: items))
        .chartLegend(.hidden)
    }
}

// MARK: - GachaTimeChart

@available(iOS 16.0, *)
private struct GachaTimeChart: View {
    var gachaViewModel: GachaViewModel
    let type: GachaType
    let formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        fmt.timeStyle = .none
        return fmt
    }()

    var items: [GachaItem] { gachaViewModel.gachaItems }

    var itemsFiltered: [GachaItem] {
        items.filter { item in
            item.gachaType == type
        }
    }

    var gachaTypeDateCount: [GachaTypeDateCountAndIfContain5Star] {
        let dates = Set<Date>.init(itemsFiltered.map { $0.time })
        return dates.map { date in
            GachaTypeDateCountAndIfContain5Star(
                date: date,
                count: itemsFiltered
                    .filter { $0.time <= date }
                    .count,
                type: type,
                contain5Star: itemsFiltered
                    .filter { $0.time == date }
                    .contains(where: { $0.rankType == .five }) ? "true" :
                    "false"
            )
        }.sorted(by: { $0.date > $1.date })
    }

    var dayDiffOfminMax: Int {
        let times = items.map { $0.time }
        let min = times.min()!
        let max = times.max()!

        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: min, to: max)
        return components.day!
    }

    var color: Color {
        switch type {
        case .character: return .green
        case .standard: return .cyan
        case .weapon: return .mint
        default: return .cyan
        }
    }

    var body: some View {
        Chart(gachaTypeDateCount) {
            LineMark(
                x: .value("日期", $0.date),
                y: .value("抽数", $0.count)
            )
            .foregroundStyle(color)
//            .foregroundStyle(by: .value("祈愿类型", $0.type.localizedDescription()))
            PointMark(x: .value("日期", $0.date), y: .value("抽数", $0.count))
                .foregroundStyle(by: .value("是否有五星", $0.contain5Star))
        }
        .chartLegend(.hidden)
//        .chartYAxis(content: {
//            AxisMarks(position: .leading)
//        })
        .padding(.top)
        .frame(height: 200)
        .chartForegroundStyleScale([
            "true": .orange,
            "false": .blue.opacity(0),
        ])
//        .chartForegroundStyleScale([
//            GachaType.standard.localizedDescription(): .green,
//            GachaType.character.localizedDescription(): .blue,
//            GachaType.weapon.localizedDescription(): .yellow,
//        ])
//        ScrollView(.horizontal) {

//            .frame(width: CGFloat(dayDiffOfminMax) * 5, height: CGFloat(items.filter( {$0.gachaType == .character}).count))
//        }
    }
}

// MARK: - GachaTypeDateCountAndIfContain5Star

struct GachaTypeDateCountAndIfContain5Star: Hashable, Identifiable {
    let date: Date
    var count: Int
    let type: GachaType
    let contain5Star: String

    var id: Int {
        hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(type)
    }
}
