//
//  LockScreenResinWidgetRectangular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenResinWidgetRectangular<T>: View where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .fullColor:
            switch result {
            case .success(let data):
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let size: CGFloat = 40
                            Text("\(data.resinInfo.currentResin)")
                                .font(.system(size: size, design: .rounded))
                                .minimumScaleFactor(0.5)
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: size*1/2))
                                .minimumScaleFactor(0.5)
                        }
                        .widgetAccentable()
                        .foregroundColor(Color("iconColor.resin.middle"))
                        if data.resinInfo.isFull {
                            Text("已回满")
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("\(data.resinInfo.recoveryTime.completeTimePointFromNow()) 回满")
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
            case .failure(_):
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let size: CGFloat = 40
                            Text(Image(systemName: "ellipsis"))
                                .font(.system(size: size, design: .rounded))
                                .minimumScaleFactor(0.5)
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: size*1/2))
                                .minimumScaleFactor(0.5)
                        }
                        .widgetAccentable()
                        .foregroundColor(.cyan)
                        Text(Image("icon.resin"))
                            .font(.footnote)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
            }
        default:
            switch result {
            case .success(let data):
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let size: CGFloat = 40
                            Text("\(data.resinInfo.currentResin)")
                                .font(.system(size: size, design: .rounded))
                                .minimumScaleFactor(0.5)
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: size*1/2))
                                .minimumScaleFactor(0.5)
                        }
                        .foregroundColor(.primary)
                        .widgetAccentable()
                        if data.resinInfo.isFull {
                            Text("已回满")
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.gray)
                        } else {
                            Text("\(data.resinInfo.recoveryTime.completeTimePointFromNow()) 回满")
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
            case .failure(_):
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let size: CGFloat = 40
                            Text(Image(systemName: "ellipsis"))
                                .font(.system(size: size, design: .rounded))
                                .minimumScaleFactor(0.5)
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: size*1/2))
                                .minimumScaleFactor(0.5)
                        }
                        .widgetAccentable()
                        Text(Image("icon.resin"))
                            .font(.footnote)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }

    }
}



struct FitSystemFont: ViewModifier {
    var lineLimit: Int
    var minimumScaleFactor: CGFloat
    var percentage: CGFloat

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .font(.system(size: min(geometry.size.width, geometry.size.height) * percentage))
                .lineLimit(self.lineLimit)
                .minimumScaleFactor(self.minimumScaleFactor)
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}

extension View {
    func fitSystemFont(lineLimit: Int = 1, minimumScaleFactor: CGFloat = 0.01, percentage: CGFloat = 1) -> ModifiedContent<Self, FitSystemFont> {
        return modifier(FitSystemFont(lineLimit: lineLimit, minimumScaleFactor: minimumScaleFactor, percentage: percentage))
    }
}
