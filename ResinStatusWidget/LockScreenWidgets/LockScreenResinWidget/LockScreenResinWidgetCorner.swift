//
//  LockScreenResinWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinWidgetCorner<T>: View where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>
    var text: String {
        switch result {
        case .success(let data):
            if data.resinInfo.isFull {
                return String(format: NSLocalizedString("160, 已回满", comment: "resin"))
            } else {
                return "\(data.resinInfo.currentResin), \(data.resinInfo.recoveryTime.describeIntervalShort()), \(data.resinInfo.recoveryTime.completeTimePointFromNowShort())"
            }
        case .failure(_):
            return "原粹树脂".localized
        }
    }

    var body: some View {
        Image("icon.resin")
            .resizable()
            .scaledToFit()
            .padding(4)
            .widgetLabel(text)
    }
}




