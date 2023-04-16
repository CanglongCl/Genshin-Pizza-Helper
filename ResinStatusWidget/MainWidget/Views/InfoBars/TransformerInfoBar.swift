//
//  TransformerInfoBar.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//

import HBMihoyoAPI
import SwiftUI

struct TransformerInfoBar: View {
    let transformerInfo: TransformerInfo

    var isTransformerCompleteImage: some View {
        transformerInfo.isComplete
            ? Image(systemName: "exclamationmark")
            .overlayImageWithRingProgressBar(
                transformerInfo.percentage,
                scaler: 0.78
            )
            : Image(systemName: "hourglass")
            .overlayImageWithRingProgressBar(transformerInfo.percentage)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("参量质变仪")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .shadow(color: .white, radius: 1)
            isTransformerCompleteImage

                .frame(maxWidth: 13, maxHeight: 13)
                .foregroundColor(Color("textColor3"))
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text(
                    transformerInfo.recoveryTime
                        .describeIntervalShort(
                            finishedTextPlaceholder: "可使用"
                                .localized
                        )
                )
                .foregroundColor(Color("textColor3"))
                .lineLimit(1)
                .font(.system(.body, design: .rounded))
                .minimumScaleFactor(0.2)
            }
        }
    }
}
