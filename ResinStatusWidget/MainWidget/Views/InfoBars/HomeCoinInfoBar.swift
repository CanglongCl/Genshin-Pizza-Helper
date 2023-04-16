//
//  ResinInfoBar.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//

import HBMihoyoAPI
import SwiftUI

struct HomeCoinInfoBar: View {
    let homeCoinInfo: HomeCoinInfo

    var isHomeCoinFullImage: some View {
        homeCoinInfo.maxHomeCoin == 300
            ? Image(systemName: "leaf.fill")
            .overlayImageWithRingProgressBar(homeCoinInfo.percentage)
            : (
                (homeCoinInfo.isFull)
                    ? Image(systemName: "exclamationmark")
                    .overlayImageWithRingProgressBar(
                        homeCoinInfo.percentage,
                        scaler: 0.78
                    )
                    : Image(systemName: "leaf.fill")
                    .overlayImageWithRingProgressBar(homeCoinInfo.percentage)
            )
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("洞天宝钱")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .shadow(color: .white, radius: 1)
            isHomeCoinFullImage
                .frame(maxWidth: 13, maxHeight: 13)
                .foregroundColor(Color("textColor3"))
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text("\(homeCoinInfo.currentHomeCoin)")
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
            }
        }
    }
}
