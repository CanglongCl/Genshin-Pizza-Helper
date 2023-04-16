//
//  ResinRecoveryActivityWidget.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/19.
//

#if canImport(ActivityKit)
import ActivityKit
import Foundation
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct ResinRecoveryActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(
            for: ResinRecoveryAttributes
                .self
        ) { context in
            ResinRecoveryActivityWidgetLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Image(systemName: "person.fill")
                        Text(context.attributes.accountName)
                    }
                    .foregroundColor(Color("textColor.appIconLike"))
                    .font(.caption2)
                    .padding(.leading)
                }
                .contentMargins(.trailing, 15)
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .center, spacing: 4) {
                        Image("AppIconSmall")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 15)
                        Text("披萨小助手")
                            .foregroundColor(Color("textColor.appIconLike"))
                            .font(.caption2)
                    }
                    .padding(.trailing)
                }
                .contentMargins(.leading, 15)
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        HStack {
                            Image("树脂")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 40)
                            VStack(alignment: .leading) {
                                Text(
                                    "距离\(context.state.next20ResinCount)树脂"
                                )
                                .font(.caption2)
                                Text(
                                    timerInterval: Date() ... context.state
                                        .next20ResinRecoveryTime,
                                    countsDown: true
                                )
                                .multilineTextAlignment(.leading)
                                .font(.system(.title2, design: .rounded))
                                .foregroundColor(
                                    Color("textColor.originResin")
                                )
                            }
                            .gridColumnAlignment(.leading)
                            .frame(width: 100)
                        }
                        Spacer()
                        HStack {
                            Image("浓缩树脂")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 40)
                            VStack(alignment: .leading) {
                                Text("距离160树脂")
                                    .font(.caption2)
                                Text(
                                    timerInterval: Date() ... context.state
                                        .resinFullTime,
                                    countsDown: true
                                )
                                .multilineTextAlignment(.leading)
                                .font(.system(.title2, design: .rounded))
                                .foregroundColor(
                                    Color("textColor.originResin")
                                )
                            }
                            .gridColumnAlignment(.leading)
                            .frame(width: 100)
                        }
                    }
                    .foregroundColor(Color("textColor3"))
                }
            } compactLeading: {
                Image("树脂").resizable().scaledToFit()
            } compactTrailing: {
                Text(
                    timerInterval: Date() ... context.state
                        .next20ResinRecoveryTime,
                    countsDown: true,
                    showsHours: false
                )
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .foregroundColor(Color("textColor2"))
            } minimal: {
                Image("树脂").resizable().scaledToFit()
            }
        }
    }
}

@available(iOS 16.1, *)
struct ResinRecoveryActivityWidgetLockScreenView: View {
    let context: ActivityViewContext<ResinRecoveryAttributes>

    var useNoBackground: Bool { context.state.background == .noBackground }

    var body: some View {
        HStack {
            Grid(verticalSpacing: 7) {
                if context.state.showNext20Resin {
                    GridRow {
                        Image("树脂")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 38)
                        VStack(alignment: .leading) {
                            Text("距离\(context.state.next20ResinCount)树脂")
                                .font(.caption2)
                            Text(
                                timerInterval: Date() ... context.state
                                    .next20ResinRecoveryTime,
                                countsDown: true
                            )
                            .multilineTextAlignment(.leading)
                            .font(.system(.title2, design: .rounded))
                        }
                        .gridColumnAlignment(.leading)
//                        .frame(width: 140)
                    }
                }
                GridRow {
                    Image("浓缩树脂")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 35)
                    VStack(alignment: .leading) {
                        Text("距离160树脂")
                            .font(.caption2)
                        Text(
                            timerInterval: Date() ... context.state
                                .resinFullTime,
                            countsDown: true
                        )
                        .multilineTextAlignment(.leading)
                        .font(.system(.title2, design: .rounded))
                    }
                    .gridColumnAlignment(.leading)
//                    .frame(width: 140)
                }
                if context.state.showExpeditionInfo {
                    GridRow {
                        Image("派遣探索")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 29)
                        VStack(alignment: .leading) {
                            Text("距离派遣探索全部完成")
                                .font(.caption2)
                            Text(
                                timerInterval: Date() ... context.state
                                    .allExpeditionCompleteTime,
                                countsDown: true
                            )
                            .multilineTextAlignment(.leading)
                            .font(.system(.title2, design: .rounded))
                        }
                        .gridColumnAlignment(.leading)
//                        .frame(width: 140)
                    }
                }
            }
            Spacer()
            VStack {
                Spacer()
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(context.attributes.accountName)
                }
                .font(.footnote)
                .padding(.top, 3)
                .padding(.leading, 3)
            }
        }
        .shadow(radius: useNoBackground ? 0 : 0.8)
        .foregroundColor(useNoBackground ? .primary : Color("textColor3"))
        .padding()
        .background(alignment: .center) {
            switch context.state.background {
            case .ramdom:
                WidgetBackgroundView(
                    background: .randomNamecardBackground,
                    darkModeOn: true
                )
            case let .customize(backgroundOptions):
                WidgetBackgroundView(
                    background: backgroundOptions
                        .map {
                            WidgetBackground(identifier: $0, display: $0)
                        }
                        .randomElement()!,
                    darkModeOn: true
                )
            case .noBackground:
                EmptyView()
            }
        }
    }
}
#endif
