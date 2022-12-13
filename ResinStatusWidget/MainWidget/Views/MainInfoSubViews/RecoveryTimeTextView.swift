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
        Group {
            if #available(iOS 16.0, *) {
                let future = Date(timeIntervalSinceNow: TimeInterval(resinInfo.recoveryTime.second))
                VStack(alignment: .leading, spacing: 0) {
                    Text(future, style: .relative)
                    // 下面字符串尾随一个零长空字符，区分之前的翻译
                    Text(String(localized: "\(resinInfo.recoveryTime.completeTimePointFromNow()) 回满​"))
                }
                .lineLimit(1)
            } else {
                Group {
                    if resinInfo.recoveryTime.second != 0 {
                        Text(LocalizedStringKey("\(resinInfo.recoveryTime.describeIntervalLong())\n\(resinInfo.recoveryTime.completeTimePointFromNow()) 回满"))
                    } else {
                        Text("0小时0分钟\n树脂已全部回满")
                    }
                }
                .lineLimit(2)
                .lineSpacing(1)
            }
        }
        .font(.caption)
        .minimumScaleFactor(0.2)
        .foregroundColor(Color("textColor3"))
    }
}
