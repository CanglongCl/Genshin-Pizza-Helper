//
//  WeeklyBossesBar.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/12.
//

import HBMihoyoAPI
import SwiftUI

struct WeeklyBossesInfoBar: View {
    let weeklyBossesInfo: WeeklyBossesInfo

    var isWeeklyBossesFinishedImage: some View {
        weeklyBossesInfo.isComplete
            ? Image(systemName: "checkmark")
            .overlayImageWithRingProgressBar(1.0, scaler: 0.70)
            : Image(systemName: "questionmark")
            .overlayImageWithRingProgressBar(1.0)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("征讨领域")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .shadow(color: .white, radius: 1)
            isWeeklyBossesFinishedImage
                .frame(width: 13, height: 13)
                .foregroundColor(Color("textColor3"))
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text("\(weeklyBossesInfo.hasUsedResinDiscountNum)")
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
                Text(" / \(weeklyBossesInfo.resinDiscountNumLimit)")
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.caption, design: .rounded))
                    .minimumScaleFactor(0.2)
            }
        }
    }
}
