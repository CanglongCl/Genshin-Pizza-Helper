//
//  LargeWidgetView.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/23.
//  大号Widget布局View

import SwiftUI

struct LargeWidgetView: View {
    let userData: UserData
    let viewConfig: WidgetViewConfiguration
    let accountName: String?

    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Spacer()
                VStack(alignment: .leading) {
                    mainInfo()
                    Spacer(minLength: 18)
                    detailInfo()
                }
                
                Spacer(minLength: 30)
                VStack(alignment: .leading) {
                    ExpeditionsView(expeditions: userData.expeditionInfo.expeditions)
                    if viewConfig.showMaterialsInLargeSizeWidget {
                        Spacer(minLength: 15)
                        MaterialView()
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }



    @ViewBuilder
    func mainInfo() -> some View {
        let transformerCompleted: Bool = userData.transformerInfo.isComplete && userData.transformerInfo.obtained && viewConfig.showTransformer
        let expeditionCompleted: Bool = viewConfig.expeditionViewConfig.noticeExpeditionWhenAllCompleted ? userData.expeditionInfo.allCompleted : userData.expeditionInfo.anyCompleted
        let weeklyBossesNotice: Bool = (viewConfig.weeklyBossesShowingMethod != .neverShow) && !userData.weeklyBossesInfo.isComplete && Calendar.current.isDateInWeekend(Date())
        let dailyTaskNotice: Bool = !userData.dailyTaskInfo.isTaskRewardReceived && (userData.dailyTaskInfo.finishedTaskNum == userData.dailyTaskInfo.totalTaskNum)

        // 需要马上上号
        let needToLoginImediately: Bool = (userData.resinInfo.isFull || userData.homeCoinInfo.isFull || expeditionCompleted || transformerCompleted || dailyTaskNotice)
        // 可以晚些再上号，包括每日任务和周本
        let needToLoginSoon: Bool = !userData.dailyTaskInfo.isTaskRewardReceived || weeklyBossesNotice



        VStack(alignment: .leading, spacing: 5) {
//            Spacer()
            if let accountName = accountName {

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(accountName)

                }
                .font(.footnote)
                .foregroundColor(Color("textColor3"))
            }
            HStack(alignment: .firstTextBaseline, spacing: 2) {

                Text("\(userData.resinInfo.currentResin)")
                    .font(.system(size: 50 , design: .rounded))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color("textColor3"))
                    .shadow(radius: 1)
                Image("树脂")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 30)
                    .alignmentGuide(.firstTextBaseline) { context in
                        context[.bottom] - 0.17 * context.height
                    }
                    .shadow(radius: 0.8)
            }
            HStack {
                if needToLoginImediately {
                    if needToLoginSoon {
                        Image("exclamationmark.circle.questionmark")
                            .foregroundColor(Color("textColor3"))
                            .font(.title3)
                    } else {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(Color("textColor3"))
                            .font(.title3)
                    }
                } else if needToLoginSoon {
                    Image("hourglass.circle.questionmark")
                        .foregroundColor(Color("textColor3"))
                        .font(.title3)
                } else {
                    Image("hourglass.circle")
                        .foregroundColor(Color("textColor3"))
                        .font(.title3)
                }
                RecoveryTimeText(resinInfo: userData.resinInfo)
            }
        }
    }

    @ViewBuilder
    func detailInfo() -> some View {
        VStack(alignment: .leading, spacing: 17) {

            if userData.homeCoinInfo.maxHomeCoin != 0 {
                HomeCoinInfoBar(homeCoinInfo: userData.homeCoinInfo)
            }

            if userData.dailyTaskInfo.totalTaskNum != 0 {
                DailyTaskInfoBar(dailyTaskInfo: userData.dailyTaskInfo)
            }

            if userData.expeditionInfo.maxExpedition != 0 {
                ExpeditionInfoBar(expeditionInfo: userData.expeditionInfo, expeditionViewConfig: viewConfig.expeditionViewConfig)
            }

            if userData.transformerInfo.obtained && viewConfig.showTransformer {
                TransformerInfoBar(transformerInfo: userData.transformerInfo)
            }

            switch viewConfig.weeklyBossesShowingMethod {
            case .neverShow:
                EmptyView()
            case .disappearAfterCompleted:
                if !userData.weeklyBossesInfo.isComplete {
                    WeeklyBossesInfoBar(weeklyBossesInfo: userData.weeklyBossesInfo)
                }
            case .alwaysShow, .unknown:
                WeeklyBossesInfoBar(weeklyBossesInfo: userData.weeklyBossesInfo)
            }
        }
        .padding(.trailing)
    }
}


struct LargeWidgetViewSimplified: View {
    let userData: SimplifiedUserData
    let viewConfig: WidgetViewConfiguration
    let accountName: String?

    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Spacer()
                VStack(alignment: .leading) {
                    mainInfo()
                    Spacer(minLength: 18)
                    detailInfo()
                }

                Spacer(minLength: 30)
                VStack(alignment: .leading) {
                    ExpeditionsView(expeditions: userData.expeditionInfo.expeditions)
                    if viewConfig.showMaterialsInLargeSizeWidget {
                        Spacer(minLength: 15)
                        MaterialView()
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }



    @ViewBuilder
    func mainInfo() -> some View {
        let expeditionCompleted: Bool = viewConfig.expeditionViewConfig.noticeExpeditionWhenAllCompleted ? userData.expeditionInfo.allCompleted : userData.expeditionInfo.anyCompleted
        let dailyTaskNotice: Bool = !userData.dailyTaskInfo.isTaskRewardReceived && (userData.dailyTaskInfo.finishedTaskNum == userData.dailyTaskInfo.totalTaskNum)

        // 需要马上上号
        let needToLoginImediately: Bool = (userData.resinInfo.isFull || userData.homeCoinInfo.isFull || expeditionCompleted || dailyTaskNotice)
        // 可以晚些再上号，包括每日任务和周本
        let needToLoginSoon: Bool = !userData.dailyTaskInfo.isTaskRewardReceived



        VStack(alignment: .leading, spacing: 5) {
//            Spacer()
            if let accountName = accountName {

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(accountName)

                }
                .font(.footnote)
                .foregroundColor(Color("textColor3"))
            }
            HStack(alignment: .firstTextBaseline, spacing: 2) {

                Text("\(userData.resinInfo.currentResin)")
                    .font(.system(size: 50 , design: .rounded))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color("textColor3"))
                    .shadow(radius: 1)
                Image("树脂")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 30)
                    .alignmentGuide(.firstTextBaseline) { context in
                        context[.bottom] - 0.17 * context.height
                    }
                    .shadow(radius: 0.8)
            }
            HStack {
                if needToLoginImediately {
                    if needToLoginSoon {
                        Image("exclamationmark.circle.questionmark")
                            .foregroundColor(Color("textColor3"))
                            .font(.title3)
                    } else {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(Color("textColor3"))
                            .font(.title3)
                    }
                } else if needToLoginSoon {
                    Image("hourglass.circle.questionmark")
                        .foregroundColor(Color("textColor3"))
                        .font(.title3)
                } else {
                    Image("hourglass.circle")
                        .foregroundColor(Color("textColor3"))
                        .font(.title3)
                }
                RecoveryTimeText(resinInfo: userData.resinInfo)
            }
        }
    }

    @ViewBuilder
    func detailInfo() -> some View {
        VStack(alignment: .leading, spacing: 17) {

            if userData.homeCoinInfo.maxHomeCoin != 0 {
                HomeCoinInfoBar(homeCoinInfo: userData.homeCoinInfo)
            }

            if userData.dailyTaskInfo.totalTaskNum != 0 {
                DailyTaskInfoBar(dailyTaskInfo: userData.dailyTaskInfo)
            }

            if userData.expeditionInfo.maxExpedition != 0 {
                ExpeditionInfoBar(expeditionInfo: userData.expeditionInfo, expeditionViewConfig: viewConfig.expeditionViewConfig)
            }
        }
        .padding(.trailing)
    }
}
