//
//  AlternativeWatchCornerResinWidget.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
struct LockScreenAllInfoWidget: Widget {
    let kind: String = "LockScreenAllInfoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectOnlyAccountIntent.self, provider: LockScreenWidgetProvider(recommendationsTag: "的综合信息")) { entry in
            LockScreenAllInfoWidgetView(entry: entry)
        }
        .configurationDisplayName("综合信息")
        .description("所有信息，一网打尽")
        .supportedFamilies([.accessoryRectangular])
    }
}

@available (iOS 16.0, *)
struct LockScreenAllInfoWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    let entry: LockScreenWidgetProvider.Entry
    var dataKind: WidgetDataKind { entry.widgetDataKind }
    var accountName: String? { entry.accountName }

    var url: URL? {
            let errorURL: URL = {
                var components = URLComponents()
                components.scheme = "ophelperwidget"
                components.host = "accountSetting"
                components.queryItems = [
                    .init(name: "accountUUIDString", value: entry.accountUUIDString)
                ]
                return components.url!
            }()

            switch entry.widgetDataKind {
            case .normal(let result):
                switch result {
                case .success(_):
                    return nil
                case .failure(_):
                    return errorURL
                }
            case .simplified(let result):
                switch result {
                case .success(_):
                    return nil
                case .failure(_):
                    return errorURL
                }
            }
        }

    var body: some View {
        Group {
            switch widgetRenderingMode {
            case .fullColor:
                switch dataKind {
                case .normal(let result):
                    switch result {
                    case .success(let data):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.resin"))
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.expedition"))
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.expeditionInfo.currentOngoingTask)")
                                    Text(" / \(data.expeditionInfo.maxExpedition)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.homeCoin"))
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .foregroundColor(Color("iconColor.dailyTask"))
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.dailyTaskInfo.finishedTaskNum)")
                                    Text(" / \(data.dailyTaskInfo.totalTaskNum)")
                                        .font(.caption)
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .foregroundColor(Color("iconColor.transformer"))
                                    .widgetAccentable()
                                Text(data.transformerInfo.recoveryTime.describeIntervalShort(finishedTextPlaceholder: "可使用"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.weeklyBosses"))
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.weeklyBossesInfo.hasUsedResinDiscountNum)")
                                    Text(" / \(data.weeklyBossesInfo.resinDiscountNumLimit)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                        }
                    case .failure(_):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                case .simplified(let result):
                    switch result {
                    case .success(let data):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.resin"))
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.expedition"))
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.expeditionInfo.currentOngoingTask)")
                                    Text(" / \(data.expeditionInfo.maxExpedition)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                    .foregroundColor(Color("iconColor.homeCoin"))
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .foregroundColor(Color("iconColor.dailyTask"))
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.dailyTaskInfo.finishedTaskNum)")
                                    Text(" / \(data.dailyTaskInfo.totalTaskNum)")
                                        .font(.caption)
                                }
                            }
                        }
                    case .failure(_):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                }

            default:
                switch dataKind {
                case .normal(let result):
                    switch result {
                    case .success(let data):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.expeditionInfo.currentOngoingTask)")
                                    Text(" / \(data.expeditionInfo.maxExpedition)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.dailyTaskInfo.finishedTaskNum)")
                                    Text(" / \(data.dailyTaskInfo.totalTaskNum)")
                                        .font(.caption)
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(data.transformerInfo.recoveryTime.describeIntervalShort(finishedTextPlaceholder: "可使用"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.weeklyBossesInfo.hasUsedResinDiscountNum)")
                                    Text(" / \(data.weeklyBossesInfo.resinDiscountNumLimit)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                        }
                    case .failure(_):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.transformer"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.weeklyBosses"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.gray)
                    }
                case .simplified(let result):
                    switch result {
                    case .success(let data):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text("\(data.resinInfo.currentResin)")
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.expeditionInfo.currentOngoingTask)")
                                    Text(" / \(data.expeditionInfo.maxExpedition)")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(data.homeCoinInfo.currentHomeCoin)")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("\(data.dailyTaskInfo.finishedTaskNum)")
                                    Text(" / \(data.dailyTaskInfo.totalTaskNum)")
                                        .font(.caption)
                                }
                            }
                        }
                    case .failure(_):
                        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 3, verticalSpacing: 2) {
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.resin"))")
                                    .widgetAccentable()
                                Text(Image(systemName: "ellipsis"))
                                Spacer()
                                Text("\(Image("icon.expedition"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                                Spacer()
                            }
                            GridRow(alignment: .lastTextBaseline) {
                                Text("\(Image("icon.homeCoin"))")
                                    .widgetAccentable()
                                Text("\(Image(systemName: "ellipsis"))")
                                Spacer()
                                Text("\(Image("icon.dailyTask"))")
                                    .widgetAccentable()
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                        }
                        .foregroundColor(.gray)
                    }
                }

            }
        }
        .widgetURL(url)

    }
}

