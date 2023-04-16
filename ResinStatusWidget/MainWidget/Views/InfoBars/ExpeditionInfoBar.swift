//
//  ExpeditionInfoBar.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//

import HBMihoyoAPI
import SwiftUI

struct ExpeditionInfoBar: View {
    let expeditionInfo: ExpeditionInfo
    let expeditionViewConfig: ExpeditionViewConfiguration

    var notice: Bool {
        expeditionViewConfig.noticeExpeditionWhenAllCompleted ? expeditionInfo
            .allCompleted : expeditionInfo.anyCompleted
    }

    var isExpeditionAllCompleteImage: some View {
        notice
            ? Image(systemName: "exclamationmark")
            .overlayImageWithRingProgressBar(
                expeditionViewConfig
                    .noticeExpeditionWhenAllCompleted ? expeditionInfo
                    .allCompletedPercentage : expeditionInfo
                    .nextCompletePercentage,
                scaler: 0.78
            )
            : Image(systemName: "figure.walk")
            .overlayImageWithRingProgressBar(
                expeditionViewConfig
                    .noticeExpeditionWhenAllCompleted ? expeditionInfo
                    .allCompletedPercentage : expeditionInfo
                    .nextCompletePercentage,
                scaler: 1,
                offset: (0.3, 0)
            )
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("派遣探索")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .shadow(color: .white, radius: 1)
            isExpeditionAllCompleteImage

                .frame(maxWidth: 13, maxHeight: 13)
                .foregroundColor(Color("textColor3"))

            switch expeditionViewConfig.expeditionShowingMethod {
            case .byNum, .unknown:
                HStack(alignment: .lastTextBaseline, spacing: 1) {
                    Text("\(expeditionInfo.currentOngoingTask)")
                        .foregroundColor(Color("textColor3"))
                        .font(.system(.body, design: .rounded))
                        .minimumScaleFactor(0.2)
                    Text(" / \(expeditionInfo.maxExpedition)")
                        .foregroundColor(Color("textColor3"))
                        .font(.system(.caption, design: .rounded))
                        .minimumScaleFactor(0.2)
                }
            case .byTimePoint:
                if expeditionViewConfig.noticeExpeditionWhenAllCompleted {
                    Text(
                        expeditionInfo.allCompleteTime
                            .completeTimePointFromNow(
                                finishedTextPlaceholder: "已全部完成"
                                    .localized
                            )
                    )
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                } else {
                    Text(
                        expeditionInfo.nextCompleteTime
                            .completeTimePointFromNow(
                                finishedTextPlaceholder:
                                String(
                                    format: NSLocalizedString(
                                        "%lld个已完成",
                                        comment: "%lld done"
                                    ),
                                    expeditionInfo
                                        .maxExpedition - expeditionInfo
                                        .currentOngoingTask
                                )
                            )
                    )
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                }
            case .byTimeInterval:
                if expeditionViewConfig.noticeExpeditionWhenAllCompleted {
                    Text(
                        expeditionInfo.allCompleteTime
                            .describeIntervalShort(
                                finishedTextPlaceholder: "已全部完成"
                                    .localized
                            )
                    )
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                } else {
                    Text(
                        expeditionInfo.nextCompleteTime
                            .describeIntervalShort(
                                finishedTextPlaceholder: "已全部完成"
                                    .localized
                            )
                    )
                    .foregroundColor(Color("textColor3"))
                    .font(.system(.body, design: .rounded))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                }
            }
        }
    }
}
