//
//  AccountBasicInfosView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/9/13.
//

import SwiftUI

struct AccountBasicInfosView: View {
    var basicAccountInfo: BasicInfos?
    let is_zh_CN: Bool = Locale.current.languageCode == "zh"

    var body: some View {
        if let basicAccountInfo = basicAccountInfo {
            Section {
                if is_zh_CN {
                    HStack {
                        VStack(spacing: 5) {
                            InfoPreviewer(title: "活跃天数", content: "\(basicAccountInfo.stats.activeDayNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "获得角色", content: "\(basicAccountInfo.stats.avatarNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "深境螺旋", content: basicAccountInfo.stats.spiralAbyss, contentStyle: .capsule)
                            InfoPreviewer(title: "普通宝箱", content: "\(basicAccountInfo.stats.commonChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "珍贵宝箱", content: "\(basicAccountInfo.stats.preciousChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "风神瞳", content: "\(basicAccountInfo.stats.anemoculusNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "雷神瞳", content: "\(basicAccountInfo.stats.electroculusNumber)", contentStyle: .capsule)
                        }
                        VStack(spacing: 5) {
                            InfoPreviewer(title: "成就达成", content: "\(basicAccountInfo.stats.achievementNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "解锁锚点", content: "\(basicAccountInfo.stats.wayPointNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "解锁秘境", content: "\(basicAccountInfo.stats.domainNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "精致宝箱", content: "\(basicAccountInfo.stats.exquisiteChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "华丽宝箱", content: "\(basicAccountInfo.stats.luxuriousChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "岩神瞳", content: "\(basicAccountInfo.stats.geoculusNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "草神瞳", content: "\(basicAccountInfo.stats.dendroculusNumber)", contentStyle: .capsule)
                        }
                    }
                } else {
                    VStack(spacing: 5) {
                        Group {
                            InfoPreviewer(title: "活跃天数", content: "\(basicAccountInfo.stats.activeDayNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "获得角色", content: "\(basicAccountInfo.stats.avatarNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "深境螺旋", content: basicAccountInfo.stats.spiralAbyss, contentStyle: .capsule)
                            InfoPreviewer(title: "成就达成", content: "\(basicAccountInfo.stats.achievementNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "解锁锚点", content: "\(basicAccountInfo.stats.wayPointNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "解锁秘境", content: "\(basicAccountInfo.stats.domainNumber)", contentStyle: .capsule)
                        }
                        Group {
                            InfoPreviewer(title: "普通宝箱", content: "\(basicAccountInfo.stats.commonChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "珍贵宝箱", content: "\(basicAccountInfo.stats.preciousChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "精致宝箱", content: "\(basicAccountInfo.stats.exquisiteChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "华丽宝箱", content: "\(basicAccountInfo.stats.luxuriousChestNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "风神瞳", content: "\(basicAccountInfo.stats.anemoculusNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "雷神瞳", content: "\(basicAccountInfo.stats.electroculusNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "岩神瞳", content: "\(basicAccountInfo.stats.geoculusNumber)", contentStyle: .capsule)
                            InfoPreviewer(title: "草神瞳", content: "\(basicAccountInfo.stats.dendroculusNumber)", contentStyle: .capsule)
                        }
                    }
                }
            } header: {
                Text("数据总览")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.bottom, 6.5)
            }
            Section {
                ScrollView(.horizontal) {
                    WorldExplorationsViewAll(basicAccountInfo: basicAccountInfo)
                }
            } header: {
                Text("世界探索")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.bottom, 5)
            }
            // 一段空白区域用于填充底部，垫高整体
            Spacer(minLength: 50)
        } else {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
}

private struct WorldExplorationsView: View {
    var data: BasicInfos.WorldExploration

    var body: some View {
        VStack {
            WebImage(urlStr: data.icon)
                .frame(width: 70, height: 70)
            Text(data.name)
            Text(calculatePercentage(value: Double(data.explorationPercentage) / Double(1000)))
                .font(.footnote)
        }
    }

    func calculatePercentage(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: value as NSNumber) ?? "Error"
    }
}

private struct WorldOfferingsExplorationsView: View {
    var data: BasicInfos.WorldExploration.Offering

    var body: some View {
        VStack(alignment: .center) {
            WebImage(urlStr: data.icon)
                .frame(width: 30, height: 30)
            Text(data.name)
            Text("Lv. \(data.level)")
                .font(.footnote)
        }
    }
}

private struct WorldExplorationsViewAll: View {
    let basicAccountInfo: BasicInfos
    var body: some View {
        if #available(iOS 16, *) {
            Grid(horizontalSpacing: 20, verticalSpacing: 10) {
                GridRow {
                    ForEach(basicAccountInfo.worldExplorations.sorted {
                        $0.id < $1.id
                    }, id: \.id) { worldData in
                        WorldExplorationsView(data: worldData)
                            .frame(minWidth: 80)
                    }
                }
                GridRow {
                    ForEach(basicAccountInfo.worldExplorations.sorted {
                        $0.id < $1.id
                    }, id: \.id) { worldData in
                        VStack(alignment: .center, spacing: 10) {
                            if let offerings = worldData.offerings {
                                if worldData.id != 6 {  // 取消层岩地上的流明石的显示
                                    ForEach(offerings, id:\.name) { offering in
                                        WorldOfferingsExplorationsView(data: offering)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            HStack(alignment: .top) {
                ForEach(basicAccountInfo.worldExplorations.sorted {
                    $0.id < $1.id
                }, id: \.id) { worldData in
                    VStack(alignment: .center, spacing: 10) {
                        WorldExplorationsView(data: worldData)
                        if let offerings = worldData.offerings {
                            if worldData.id != 6 {  // 取消层岩地上的流明石的显示
                                ForEach(offerings, id:\.name) { offering in
                                    WorldOfferingsExplorationsView(data: offering)
                                }
                            }
                        } else {
                            Spacer()
                        }
                    }
                    .frame(minWidth: 80)
                }
            }
            .padding(.vertical, 5)
        }
    }
}
