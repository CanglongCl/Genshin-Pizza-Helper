//
//  LockScreenHomeCoinWidgetCircular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/11.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct AlternativeLockScreenResinWidgetCircular<T>: View where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .accented:
            VStack(spacing: 0) {
                Image("icon.resin")
                    .resizable()
                    .scaledToFit()
                switch result {
                case .success(let data):
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                case .failure(_):
                    Image(systemName: "ellipsis")
                }
            }
            #if os(watchOS)
            .padding(.vertical, 2)
            .padding(.top, 1)
            #else
            .padding(.vertical, 2)
            #endif
            .widgetAccentable()
        case .fullColor:
            VStack(spacing: 0) {
                LinearGradient(colors: [.init("iconColor.resin.dark"), .init("iconColor.resin.middle"), .init("iconColor.resin.light")], startPoint: .top, endPoint: .bottom)
                    .mask(Image("icon.resin")
                        .resizable()
                        .scaledToFit())
                switch result {
                case .success(let data):
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                case .failure(_):
                    Image(systemName: "ellipsis")
                }
            }
            #if os(watchOS)
            .padding(.vertical, 2)
            .padding(.top, 1)
            #else
            .padding(.vertical, 2)
            #endif
        default:
            VStack(spacing: 0) {
                Image("icon.resin")
                    .resizable()
                    .scaledToFit()
                switch result {
                case .success(let data):
                    Text("\(data.resinInfo.currentResin)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                case .failure(_):
                    Image(systemName: "ellipsis")
                }
            }
            #if os(watchOS)
            .padding(.vertical, 2)
            .padding(.top, 1)
            #else
            .padding(.vertical, 2)
            #endif
        }
    }
}

