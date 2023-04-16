//
//  LockScreenHomeCoinWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import HBMihoyoAPI
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenHomeCoinWidgetCorner<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var text: String {
        switch result {
        case let .success(data):
            return "\(data.homeCoinInfo.currentHomeCoin), \(data.homeCoinInfo.recoveryTime.describeIntervalShort(finishedTextPlaceholder: "已填满".localized))"
        case .failure:
            return "洞天宝钱".localized
        }
    }

    var body: some View {
        Image("icon.homeCoin")
            .resizable()
            .scaledToFit()
            .padding(3)
            .widgetLabel(text)
    }
}
