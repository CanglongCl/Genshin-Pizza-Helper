//
//  LockScreenHomeCoinWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import HBMihoyoAPI
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenExpeditionWidgetCorner<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var text: String {
        switch result {
        case let .success(data):
            return "\(data.expeditionInfo.currentOngoingTask)/\(data.expeditionInfo.maxExpedition) \(data.expeditionInfo.nextCompleteTimeIgnoreFinished.describeIntervalLong(finishedTextPlaceholder: "已全部完成".localized))"
        case .failure:
            return "探索派遣".localized
        }
    }

    var body: some View {
        Image("icon.expedition")
            .resizable()
            .scaledToFit()
            .padding(3.5)
            .widgetLabel(text)
    }
}
