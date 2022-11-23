//
//  DetailInfoView.swift
//  ResinStatusWidgetExtension
//
//  Created by Bill Haku on 2022/8/6.
//  其他游戏内信息

import Foundation
import SwiftUI

struct DetailInfo: View {
    let userData: UserData
    let viewConfig: WidgetViewConfiguration

    var body: some View {

        VStack(alignment: .leading, spacing: 13) {
            
            if userData.homeCoinInfo.maxHomeCoin != 0 {
                HomeCoinInfoBar(homeCoinInfo: userData.homeCoinInfo)
            }
            
            if userData.dailyTaskInfo.totalTaskNum != 0 {
                DailyTaskInfoBar(dailyTaskInfo: userData.dailyTaskInfo)
            }
            
            if userData.expeditionInfo.maxExpedition != 0 {
                ExpeditionInfoBar(expeditionInfo: userData.expeditionInfo, expeditionViewConfig: viewConfig.expeditionViewConfig)
            }
            
            switch viewConfig.weeklyBossesShowingMethod {
            case .disappearAfterCompleted, .unknown:
                if userData.transformerInfo.obtained && viewConfig.showTransformer {
                    if userData.weeklyBossesInfo.isComplete {
                        TransformerInfoBar(transformerInfo: userData.transformerInfo)
                    }
                }
            case .neverShow, .alwaysShow:
                if userData.transformerInfo.obtained && viewConfig.showTransformer {
                    TransformerInfoBar(transformerInfo: userData.transformerInfo)
                }
            }
            
            switch viewConfig.weeklyBossesShowingMethod {
            case .disappearAfterCompleted, .unknown:
                if !userData.weeklyBossesInfo.isComplete { WeeklyBossesInfoBar(weeklyBossesInfo: userData.weeklyBossesInfo) }
            case .neverShow:
                EmptyView()
            case .alwaysShow:
                WeeklyBossesInfoBar(weeklyBossesInfo: userData.weeklyBossesInfo)
            }
        }
        .padding(.trailing)
    }
}

struct DetailInfoSimplified: View {
    let userData: SimplifiedUserData
    let viewConfig: WidgetViewConfiguration

    var body: some View {

        VStack(alignment: .leading, spacing: 13) {

            if userData.homeCoinInfo.maxHomeCoin != 0 {
                HomeCoinInfoBar(homeCoinInfo: userData.homeCoinInfo)
            }

            if userData.dailyTaskInfo.totalTaskNum != 0 {
                DailyTaskInfoBar(dailyTaskInfo: userData.dailyTaskInfo)
            }

            if userData.expeditionInfo.maxExpedition != 0 {
                ExpeditionInfoBar(expeditionInfo: userData.expeditionInfo, expeditionViewConfig: .init(noticeExpeditionWhenAllCompleted: true, expeditionShowingMethod: .byNum))
            }
        }
        .padding(.trailing)
    }
}
