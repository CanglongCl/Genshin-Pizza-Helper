//
//  LockScreenHomeCoinWidgetCircular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/11.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenHomeCoinWidgetCircular: View {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: FetchResult

    var body: some View {
        switch widgetRenderingMode {
        case .accented:
            VStack(spacing: 0) {
                Image("icon.homeCoin")
                    .resizable()
                    .scaledToFit()
                switch result {
                case .success(let data):
                    Text("\(data.homeCoinInfo.currentHomeCoin)")
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
                Image("icon.homeCoin")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("iconColor.homeCoin.lightBlue"))
                switch result {
                case .success(let data):
                    Text("\(data.homeCoinInfo.currentHomeCoin)")
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
                Image("icon.homeCoin")
                    .resizable()
                    .scaledToFit()

                switch result {
                case .success(let data):
                    Text("\(data.homeCoinInfo.currentHomeCoin)")
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

