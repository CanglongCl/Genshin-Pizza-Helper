//
//  WidgetBackgroundView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  Widget背景提供

import SwiftUI
import WidgetKit

struct WidgetBackgroundView: View {
    @Environment(\.colorScheme)
    var colorScheme: ColorScheme
    @Environment(\.widgetFamily)
    var widgetFamily: WidgetFamily
    let background: WidgetBackground
    let darkModeOn: Bool

    var backgroundColors: [Color] { background.colors }
    var backgroundIconName: String? { background.iconName }
    var backgroundImageName: String? { background.imageName }

    var body: some View {
        ZStack {
            if !backgroundColors.isEmpty {
                LinearGradient(
                    colors: backgroundColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            if let backgroundIconName = backgroundIconName {
                GeometryReader { g in
                    Image(backgroundIconName)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.05)
                        .padding()
                        .frame(width: g.size.width, height: g.size.height)
                }
            }

            if let backgroundImageName = backgroundImageName {
                switch widgetFamily {
                case .systemSmall:
                    GeometryReader { g in
                        Image(backgroundImageName)
                            .resizable()
                            .scaledToFill()
                            .offset(x: -g.size.width)
                    }
                case .systemMedium:
                    Image(backgroundImageName)
                        .resizable()
                        .scaledToFill()
                case .systemLarge:
                    GeometryReader { g in
                        Image(backgroundImageName)
                            .resizable()
                            .scaledToFill()
                            .offset(x: -g.size.width)
                    }
                default:
                    Image(backgroundImageName)
                        .resizable()
                        .scaledToFill()
                }
            }

            if colorScheme == .dark, darkModeOn {
                Color.black
                    .opacity(0.3)
            }
        }
    }
}
