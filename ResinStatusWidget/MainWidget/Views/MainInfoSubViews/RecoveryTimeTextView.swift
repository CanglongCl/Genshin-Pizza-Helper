//
//  RecoveryTimeTextView.swift
//  ResinStatusWidgetExtension
//
//  Created by Bill Haku on 2022/8/6.
//  恢复时间部分布局

import Foundation
import SwiftUI

struct RecoveryTimeText: View {
    let resinInfo: ResinInfo

    var body: some View {
        if resinInfo.recoveryTime.second != 0 {
            Text(LocalizedStringKey("\(resinInfo.recoveryTime.describeIntervalLong())\n\(resinInfo.recoveryTime.completeTimePointFromNow()) 回满"))
                .font(.caption)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .foregroundColor(Color("textColor3"))
                .lineSpacing(1)
        } else {
            Text("0小时0分钟\n树脂已全部回满")
                .font(.caption)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .foregroundColor(Color("textColor3"))
                .lineSpacing(1)
        }
    }
    
}
