//
//  LockScreenResinFullTimeWidgetCircular.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/11/25.
//

import HBMihoyoAPI
import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinFullTimeWidgetCircular<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .fullColor:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: -0.5) {
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
                    .frame(height: 9)
                    switch result {
                    case let .success(data):
                        VStack(spacing: -2) {
                            if !data.resinInfo.isFull {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(
                                        size: 20,
                                        weight: .medium,
                                        design: .rounded
                                    ))
                                    .widgetAccentable()
                                let dateString: String = {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm"
                                    formatter
                                        .locale =
                                        Locale(identifier: "en_US_POSIX")
                                    return formatter
                                        .string(
                                            from: Date(
                                                timeIntervalSinceNow: TimeInterval(
                                                    data
                                                        .resinInfo.recoveryTime
                                                        .second
                                                )
                                            )
                                        )
                                }()
                                Text(dateString)
                                    .font(.system(
                                        .caption,
                                        design: .monospaced
                                    ))
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(
                                        size: 20,
                                        weight: .medium,
                                        design: .rounded
                                    ))
                                    .widgetAccentable()
                            }
                        }
                    case .failure:
                        Image("icon.resin")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 10)
                        Image(systemName: "ellipsis")
                    }
                }
                .padding(.vertical, 2)
                #if os(watchOS)
                    .padding(.vertical, 2)
                    .padding(.bottom, 1)
                #endif
            }
        default:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: -0.5) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 9)
                    switch result {
                    case let .success(data):
                        VStack(spacing: -2) {
                            if !data.resinInfo.isFull {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(
                                        size: 20,
                                        weight: .medium,
                                        design: .rounded
                                    ))
                                    .widgetAccentable()
                                let dateString: String = {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm"
                                    return formatter
                                        .string(
                                            from: Date(
                                                timeIntervalSinceNow: TimeInterval(
                                                    data
                                                        .resinInfo.recoveryTime
                                                        .second
                                                )
                                            )
                                        )
                                }()
                                Text(dateString)
                                    .font(.system(
                                        .caption,
                                        design: .monospaced
                                    ))
                                    .minimumScaleFactor(0.5)
                            } else {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(
                                        size: 20,
                                        weight: .medium,
                                        design: .rounded
                                    ))
                                    .widgetAccentable()
                            }
                        }
                    case .failure:
                        Image("icon.resin")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 10)
                        Image(systemName: "ellipsis")
                    }
                }
                .padding(.vertical, 2)
                #if os(watchOS)
                    .padding(.vertical, 2)
                    .padding(.bottom, 1)
                #endif
            }
        }
    }
}
