//
//  LockScreenHomeCoinWidgetRectangular.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/27.
//

import HBMihoyoAPI
import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenHomeCoinWidgetRectangular<T>: View
    where T: SimplifiedUserDataContainer {
    @Environment(\.widgetRenderingMode)
    var widgetRenderingMode

    let result: SimplifiedUserDataContainerResult<T>

    var body: some View {
        switch widgetRenderingMode {
        case .fullColor:
            switch result {
            case let .success(data):
                Grid(alignment: .leading) {
                    GridRow {
                        let size: CGFloat = 10
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            let iconSize: CGFloat = size * 4 / 5
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: iconSize))
                                .offset(x: -2)
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.resin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        .foregroundColor(Color("iconColor.resin"))
                        Spacer()
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let iconSize: CGFloat = size * 8 / 9
                            Text("\(Image("icon.homeCoin"))")
                                .font(.system(size: iconSize))
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.homeCoin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        .foregroundColor(Color("iconColor.homeCoin"))
                        Spacer()
                    }
                    GridRow(alignment: .lastTextBaseline) {
                        let size: CGFloat = 23
                        Text("\(data.resinInfo.currentResin)")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                        Text("\(data.homeCoinInfo.currentHomeCoin)")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                    }
                    .fixedSize()
                    .foregroundColor(.primary)
                    .widgetAccentable()
                    GridRow(alignment: .lastTextBaseline) {
                        if data.resinInfo.isFull {
                            Text("已回满")
                        } else {
                            Text(
                                "\(Date(timeIntervalSinceNow: TimeInterval(data.resinInfo.recoveryTime.second)).getRelativeDateString())"
                            )
                        }
                        Spacer()
                        if data.homeCoinInfo.isFull {
                            Text("已回满")
                        } else {
                            Text(
                                "\(Date(timeIntervalSinceNow: TimeInterval(data.homeCoinInfo.recoveryTime.second)).getRelativeDateString())"
                            )
                        }
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
            case .failure:
                Grid(alignment: .leading) {
                    GridRow(alignment: .lastTextBaseline) {
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            let size: CGFloat = 20
                            let iconSize: CGFloat = size * 4 / 5
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: iconSize))
                                .offset(x: -2)
                            Text("…")
                                .font(.system(
                                    size: size,
                                    weight: .medium,
                                    design: .rounded
                                ))
                        }
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let size: CGFloat = 20
                            let iconSize: CGFloat = size * 8 / 9
                            Text("\(Image("icon.homeCoin"))")
                                .font(.system(size: iconSize))
                            Text("…")
                                .font(.system(
                                    size: size,
                                    weight: .medium,
                                    design: .rounded
                                ))
                        }
                    }
                    .fixedSize()
                    .foregroundColor(.primary)
                    .widgetAccentable()
                    GridRow(alignment: .lastTextBaseline) {
                        Text("…")
                        Text("…")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
            }
        default:
            switch result {
            case let .success(data):
                Grid(alignment: .leading) {
                    GridRow {
                        let size: CGFloat = 10
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            let iconSize: CGFloat = size * 4 / 5
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: iconSize))
                                .offset(x: -2)
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.resin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        Spacer()
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let iconSize: CGFloat = size * 8 / 9
                            Text("\(Image("icon.homeCoin"))")
                                .font(.system(size: iconSize))
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.homeCoin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        Spacer()
                    }
                    GridRow(alignment: .lastTextBaseline) {
                        let size: CGFloat = 23
                        Text("\(data.resinInfo.currentResin)")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                        Text("\(data.homeCoinInfo.currentHomeCoin)")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                    }
                    .fixedSize()
                    .foregroundColor(.primary)
                    .widgetAccentable()
                    GridRow(alignment: .lastTextBaseline) {
                        if data.resinInfo.isFull {
                            Text("已回满")
                        } else {
                            Text(
                                "\(Date(timeIntervalSinceNow: TimeInterval(data.resinInfo.recoveryTime.second)).getRelativeDateString())"
                            )
                        }
                        Spacer()
                        if data.homeCoinInfo.isFull {
                            Text("已回满")
                        } else {
                            Text(
                                "\(Date(timeIntervalSinceNow: TimeInterval(data.homeCoinInfo.recoveryTime.second)).getRelativeDateString())"
                            )
                        }
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
            case .failure:
                Grid(alignment: .leading) {
                    GridRow {
                        let size: CGFloat = 10
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            let iconSize: CGFloat = size * 4 / 5
                            Text("\(Image("icon.resin"))")
                                .font(.system(size: iconSize))
                                .offset(x: -2)
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.resin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        Spacer()
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            let iconSize: CGFloat = size * 8 / 9
                            Text("\(Image("icon.homeCoin"))")
                                .font(.system(size: iconSize))
                            Text(
                                "LockScreenHomeCoinWidgetRectangular.homeCoin"
                                    .localized
                            )
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        }
                        Spacer()
                    }
                    GridRow(alignment: .lastTextBaseline) {
                        let size: CGFloat = 23
                        Text("…")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                        Text("…")
                            .font(.system(
                                size: size,
                                weight: .medium,
                                design: .rounded
                            ))
                        Spacer()
                    }
                    .fixedSize()
                    .foregroundColor(.primary)
                    .widgetAccentable()
                    GridRow(alignment: .lastTextBaseline) {
                        Text("…")
                        Spacer()
                        Text("…")
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}
