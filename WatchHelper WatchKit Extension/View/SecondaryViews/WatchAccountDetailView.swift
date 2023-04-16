//
//  WatchAccountDetailView.swift
//  WatchHelper WatchKit Extension
//
//  Created by Bill Haku on 2022/9/9.
//

import HBMihoyoAPI
import SwiftUI

// MARK: - WatchAccountDetailView

struct WatchAccountDetailView: View {
    var userData: Result<UserData, FetchError>
    let accountName: String?
    var uid: String?

    var body: some View {
        switch userData {
        case let .success(data):
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Divider()
                        WatchResinDetailView(resinInfo: data.resinInfo)
                        Divider()
                        VStack(alignment: .leading, spacing: 5) {
                            WatchAccountDetailItemView(
                                title: "洞天宝钱",
                                value: "\(data.homeCoinInfo.currentHomeCoin)",
                                icon: Image("洞天宝钱")
                            )
                            Divider()
                            WatchAccountDetailItemView(
                                title: "每日委托",
                                value: "\(data.dailyTaskInfo.finishedTaskNum) / \(data.dailyTaskInfo.totalTaskNum)",
                                icon: Image("每日任务")
                            )
                            Divider()
                            WatchAccountDetailItemView(
                                title: "参量质变仪",
                                value: "\(data.transformerInfo.recoveryTime.describeIntervalLong(finishedTextPlaceholder: "可使用".localized))",
                                icon: Image("参量质变仪")
                            )
                            Divider()
                            WatchAccountDetailItemView(
                                title: "周本折扣",
                                value: "\(data.weeklyBossesInfo.hasUsedResinDiscountNum) / \(data.weeklyBossesInfo.resinDiscountNumLimit)",
                                icon: Image("征讨领域")
                            )
                            Divider()
                            WatchAccountDetailItemView(
                                title: "探索派遣",
                                value: "\(data.expeditionInfo.currentOngoingTask) / \(data.expeditionInfo.maxExpedition)",
                                icon: Image("派遣探索")
                            )
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(
                                data.expeditionInfo.expeditions,
                                id: \.charactersEnglishName
                            ) { expedition in
                                WatchEachExpeditionView(
                                    expedition: expedition,
                                    useAsyncImage: true
                                )
                                .frame(maxHeight: 40)
                            }
                        }
                    }
                }
            }
            .navigationTitle(accountName ?? "")
        case .failure:
            Text("Error")
        }
    }

    func recoveryTimeText(resinInfo: ResinInfo) -> String {
        if resinInfo.recoveryTime.second != 0 {
            let localizedStr = NSLocalizedString(
                "%@ 回满",
                comment: "resin replenished"
            )
            return String(
                format: localizedStr,
                resinInfo.recoveryTime.completeTimePointFromNow()
            )
        } else {
            return "0小时0分钟\n树脂已全部回满".localized
        }
    }
}

// MARK: - WatchEachExpeditionView

private struct WatchEachExpeditionView: View {
    let expedition: Expedition
    let viewConfig: WidgetViewConfiguration = .defaultConfig
    var useAsyncImage: Bool = false
    var animationDelay: Double = 0

    var body: some View {
        HStack {
            webView(url: expedition.avatarSideIconUrl)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(
                    expedition.recoveryTime
                        .describeIntervalLong(
                            finishedTextPlaceholder: "已完成"
                                .localized
                        )
                )
                .font(.footnote)
                percentageBar(expedition.percentage)
            }
        }
        .foregroundColor(Color("textColor3"))
    }

    @ViewBuilder
    func webView(url: URL) -> some View {
        GeometryReader { g in
            if useAsyncImage {
                WebImage(urlStr: expedition.avatarSideIcon)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            } else {
                NetworkImage(url: expedition.avatarSideIconUrl)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            }
        }
        .frame(width: 25, height: 25)
    }

    @ViewBuilder
    func percentageBar(_ percentage: Double) -> some View {
        let cornerRadius: CGFloat = 3
        GeometryReader { g in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .opacity(0.3)
                    .frame(width: g.size.width, height: g.size.height)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .frame(
                        width: g.size.width * percentage,
                        height: g.size.height
                    )
            }
            .aspectRatio(30 / 1, contentMode: .fit)
        }
        .frame(height: 7)
    }
}
