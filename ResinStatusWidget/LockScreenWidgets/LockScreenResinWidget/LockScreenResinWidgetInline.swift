//
//  LockScreenResinWidgetInline.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/9/11.
//

import SwiftUI

struct LockScreenResinWidgetInline: View {
    let result: FetchResult
    
    var body: some View {
        switch result {
        case .success(let data):
            if data.resinInfo.isFull {
                Image(systemName: "moon.stars.fill")
            } else {
                Image(systemName: "moon.fill")
            }
            Text("\(data.resinInfo.currentResin)  \(data.resinInfo.recoveryTime.describeIntervalShort(finishedTextPlaceholder: "", unisStyle: .brief))")
            // 似乎不能插入自定义的树脂图片，也许以后会开放
//                Image("icon.resin")
        case .failure(_):
            Image(systemName: "moon.fill")
            Text("...")
        }
    }
}

