//
//  LockScreenResinWidgetCircular.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/9/11.
//

import Foundation
import HBMihoyoAPI
import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinWidgetCircular<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .fullColor:
            switch result {
            case let .success(data):
                Gauge(
                    value: Double(data.resinInfo.currentResin) /
                        Double(data.resinInfo.maxResin)
                ) {
                    LinearGradient(
                        colors: [
                            .init("iconColor.resin.dark"),
                            .init("iconColor.resin.middle"),
                            .init("iconColor.resin.light"),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        Image("icon.resin")
                            .resizable()
                            .scaledToFit()
                    )
                } currentValueLabel: {
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.title3, design: .rounded))
                        .minimumScaleFactor(0.4)
                }
                .gaugeStyle(
                    ProgressGaugeStyle(
                        circleColor: Color("iconColor.resin.middle")
                    )
                )
            case .failure:
                Gauge(value: 160, in: 0.0 ... 160.0) {
                    LinearGradient(
                        colors: [
                            .init("iconColor.resin.dark"),
                            .init("iconColor.resin.middle"),
                            .init("iconColor.resin.light"),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        Image("icon.resin")
                            .resizable()
                            .scaledToFit()
                    )
                } currentValueLabel: {
                    Image(systemName: "ellipsis")
                }
                .gaugeStyle(
                    ProgressGaugeStyle(
                        circleColor: Color("iconColor.resin.middle")
                    )
                )
            }
        case .accented:
            switch result {
            case let .success(data):
                Gauge(
                    value: Double(data.resinInfo.currentResin) /
                        Double(data.resinInfo.maxResin)
                ) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                } currentValueLabel: {
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.title3, design: .rounded))
                        .minimumScaleFactor(0.4)
                }
                .gaugeStyle(ProgressGaugeStyle())
            case .failure:
                Gauge(value: 160, in: 0.0 ... 160.0) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                } currentValueLabel: {
                    Image(systemName: "ellipsis")
                }
                .gaugeStyle(ProgressGaugeStyle())
            }
        default:
            switch result {
            case let .success(data):
                Gauge(
                    value: Double(data.resinInfo.currentResin) /
                        Double(data.resinInfo.maxResin)
                ) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                } currentValueLabel: {
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.title3, design: .rounded))
                        .minimumScaleFactor(0.4)
                }
                .gaugeStyle(ProgressGaugeStyle())
            case .failure:
                Gauge(value: 160, in: 0.0 ... 160.0) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                } currentValueLabel: {
                    Image(systemName: "ellipsis")
                }
                .gaugeStyle(ProgressGaugeStyle())
            }
        }
    }
}
