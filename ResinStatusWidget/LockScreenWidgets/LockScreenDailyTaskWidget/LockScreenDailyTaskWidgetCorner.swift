//
//  LockScreenHomeCoinWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import HBMihoyoAPI
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenDailyTaskWidgetCorner<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch result {
        case let .success(data):
            Image("icon.dailyTask")
                .resizable()
                .scaledToFit()
                .padding(3.5)
                .widgetLabel {
                    Gauge(
                        value: Double(data.dailyTaskInfo.finishedTaskNum),
                        in: 0 ... Double(data.dailyTaskInfo.totalTaskNum)
                    ) {
                        Text("每日委托")
                    } currentValueLabel: {
                        Text(
                            "\(data.dailyTaskInfo.finishedTaskNum) / \(data.dailyTaskInfo.totalTaskNum)"
                        )
                    } minimumValueLabel: {
                        Text(
                            "  \(data.dailyTaskInfo.finishedTaskNum)/\(data.dailyTaskInfo.totalTaskNum)  "
                        )
                    } maximumValueLabel: {
                        Text("")
                    }
                }
        case .failure:
            Image("icon.dailyTask")
                .resizable()
                .scaledToFit()
                .padding(4.5)
                .widgetLabel("每日委托".localized)
        }
    }
}
