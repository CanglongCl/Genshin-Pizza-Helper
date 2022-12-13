//
//  LockScreenResinTimerWidgetCircular.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/11/25.
//

import Foundation
import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinTimerWidgetCircular<T>: View where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .fullColor:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 3) {
                    LinearGradient(colors: [.init("iconColor.resin.dark"), .init("iconColor.resin.middle"), .init("iconColor.resin.light")], startPoint: .top, endPoint: .bottom)
                        .mask(
                            Image("icon.resin")
                                .resizable()
                                .scaledToFit()
                        )
                        .frame(height: 10)
                    switch result {
                    case .success(let data):
                        VStack(spacing: 1) {
                            if !data.resinInfo.isFull {
                                Text(Date(timeIntervalSinceNow: TimeInterval(data.resinInfo.recoveryTime.second)), style: .timer)
                                    .multilineTextAlignment(.center)
                                    .font(.system(.body, design: .monospaced))
                                    .minimumScaleFactor(0.5)
                                    .widgetAccentable()
                                    .frame(width: 50)
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundColor(Color("textColor.originResin"))
                            } else {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("textColor.originResin"))
                            }
                        }
                    case .failure(_):
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
                #endif
            }
        default:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 3) {
                    Image("icon.resin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10)
                    switch result {
                    case .success(let data):
                        VStack(spacing: 1) {
                            if !data.resinInfo.isFull {
                                Text(Date(timeIntervalSinceNow: TimeInterval(data.resinInfo.recoveryTime.second)), style: .timer)
                                    .multilineTextAlignment(.center)
                                    .font(.system(.body, design: .monospaced))
                                    .minimumScaleFactor(0.5)
                                    .widgetAccentable()
                                    .frame(width: 50)
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            } else {
                                Text("\(data.resinInfo.currentResin)")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                            }
                        }
                    case .failure(_):
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
                #endif
            }
        }
    }
}
