//
//  EachExpeditionView.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/23.
//  每条探索派遣信息View

import SwiftUI

struct EachExpeditionView: View {
    let expedition: Expedition
    let viewConfig: WidgetViewConfiguration = .defaultConfig
    var useAsyncImage: Bool = false

    var body: some View {
        HStack {
            webView(url: expedition.avatarSideIconUrl)
            VStack(alignment: .leading) {
                Text(expedition.recoveryTime.describeIntervalLong(finishedTextPlaceholder: "已完成".localized))
                    .lineLimit(1)
                    .font(.footnote)
                    .minimumScaleFactor(0.4)
                percentageBar(expedition.percentage)
                    .environment(\.colorScheme, .light)
            }
        }
        .foregroundColor(Color("textColor3"))
    }

    @ViewBuilder
    func webView(url: URL) -> some View {
        GeometryReader { g in
            if useAsyncImage {
                WebImage(urlStr: expedition.avatarSideIcon)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            } else {
                NetworkImage(url: expedition.avatarSideIconUrl)
                    .scaleEffect(1.5)
                    .scaledToFit()
                    .offset(x: -g.size.width * 0.06, y: -g.size.height * 0.25)
            }
        }
        .frame(maxWidth: 50, maxHeight: 50)
    }

    @ViewBuilder
    func percentageBar(_ percentage: Double) -> some View {

        let cornerRadius: CGFloat = 3
        if #available(iOS 15.0, iOSApplicationExtension 15.0, *) {
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width, height: g.size.height)
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.6)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width * percentage, height: g.size.height)
                        .foregroundStyle(.thickMaterial)
                }
                .aspectRatio(30/1, contentMode: .fit)
//                .preferredColorScheme(.light)
            }
            .frame(height: 7)
        } else {
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .opacity(0.3)
                        .frame(width: g.size.width, height: g.size.height)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .frame(width: g.size.width * percentage, height: g.size.height)
                }
                .aspectRatio(30/1, contentMode: .fit)
            }
            .frame(height: 7)
        }



    }
}
