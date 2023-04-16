//
//  Widget.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/11.
//  Widget配置提供

import Foundation
import SwiftUI

// MARK: - WidgetViewConfiguration

struct WidgetViewConfiguration {
    // MARK: Lifecycle

    init() {
        self.showAccountName = true
        self.showTransformer = true
        self.expeditionViewConfig = ExpeditionViewConfiguration(
            noticeExpeditionWhenAllCompleted: true,
            expeditionShowingMethod: .byNum
        )
        self.weeklyBossesShowingMethod = .alwaysShow
        self.selectedBackgrounds = [.defaultBackground]
        self.randomBackground = false
        self.isDarkModeOn = true
        self.showMaterialsInLargeSizeWidget = true
    }

    init(
        showAccountName: Bool,
        showTransformer: Bool,
        noticeExpeditionWhenAllCompleted: Bool,
        showExpeditionCompleteTime: Bool,
        showWeeklyBosses: Bool,
        noticeMessage: String?
    ) {
        self.showAccountName = showAccountName
        self.showTransformer = showTransformer
        self.expeditionViewConfig = ExpeditionViewConfiguration(
            noticeExpeditionWhenAllCompleted: noticeExpeditionWhenAllCompleted,
            expeditionShowingMethod: .byNum
        )
        self.weeklyBossesShowingMethod = .disappearAfterCompleted
        self.randomBackground = false
        self.selectedBackgrounds = [.defaultBackground]
        self.isDarkModeOn = true
        self.showMaterialsInLargeSizeWidget = true
    }

    // MARK: Internal

    static let defaultConfig = Self()

    let showAccountName: Bool
    let showTransformer: Bool
    let expeditionViewConfig: ExpeditionViewConfiguration
    let weeklyBossesShowingMethod: WeeklyBossesShowingMethod
    var noticeMessage: String?

    let isDarkModeOn: Bool

    let showMaterialsInLargeSizeWidget: Bool

    var randomBackground: Bool
    var selectedBackgrounds: [WidgetBackground]

    var background: WidgetBackground {
        guard !randomBackground else {
            return WidgetBackground.randomElementOrNamecardBackground
        }
        if selectedBackgrounds.isEmpty {
            return .defaultBackground
        } else {
            return selectedBackgrounds.randomElement()!
        }
    }

    mutating func addMessage(_ msg: String) {
        noticeMessage = msg
    }
}

// MARK: - ExpeditionViewConfiguration

struct ExpeditionViewConfiguration {
    let noticeExpeditionWhenAllCompleted: Bool
    let expeditionShowingMethod: ExpeditionShowingMethod
}

extension WidgetBackground {
    var imageName: String? {
        if BackgroundOptions.namecards.contains(identifier ?? "") {
            return identifier
        } else { return nil }
    }

    var iconName: String? {
        switch identifier {
        case "风元素":
            return "风元素图标"
        case "水元素":
            return "水元素图标"
        case "冰元素":
            return "冰元素图标"
        case "火元素":
            return "火元素图标"
        case "岩元素":
            return "岩元素图标"
        case "雷元素":
            return "雷元素图标"
        case "草元素":
            return "草元素图标"
        default:
            return nil
        }
    }

    var colors: [Color] {
        switch identifier {
        case "★★★★紫":
            return [
                Color("bgColor.purple.1"),
                Color("bgColor.purple.2"),
                Color("bgColor.purple.3"),
            ]
        case "★★★★★金":
            return [
                Color("bgColor.yellow.1"),
                Color("bgColor.yellow.2"),
                Color("bgColor.yellow.3"),
            ]
        case "★灰":
            return [
                Color("bgColor.gray.1"),
                Color("bgColor.gray.2"),
                Color("bgColor.gray.3"),
            ]
        case "★★绿":
            return [
                Color("bgColor.green.1"),
                Color("bgColor.green.2"),
                Color("bgColor.green.3"),
            ]
        case "★★★蓝":
            return [
                Color("bgColor.blue.1"),
                Color("bgColor.blue.2"),
                Color("bgColor.blue.3"),
            ]
        case "★★★★★红":
            return [
                Color("bgColor.red.1"),
                Color("bgColor.red.2"),
                Color("bgColor.red.3"),
            ]

        case "风元素":
            return [
                Color("bgColor.wind.1"),
                Color("bgColor.wind.2"),
                Color("bgColor.wind.3"),
            ]
        case "水元素":
            return [
                Color("bgColor.water.1"),
                Color("bgColor.water.2"),
                Color("bgColor.water.3"),
            ]
        case "冰元素":
            return [
                Color("bgColor.ice.1"),
                Color("bgColor.ice.2"),
                Color("bgColor.ice.3"),
            ]
        case "火元素":
            return [
                Color("bgColor.fire.1"),
                Color("bgColor.fire.2"),
                Color("bgColor.fire.3"),
            ]
        case "岩元素":
            return [
                Color("bgColor.stone.1"),
                Color("bgColor.stone.2"),
                Color("bgColor.stone.3"),
            ]
        case "雷元素":
            return [
                Color("bgColor.thunder.1"),
                Color("bgColor.thunder.2"),
                Color("bgColor.thunder.3"),
            ]
        case "草元素":
            return [
                Color("bgColor.glass.1"),
                Color("bgColor.glass.2"),
                Color("bgColor.glass.3"),
            ]
        case "纠缠之缘":
            return [
                Color("bgColor.intertwinedFate.1"),
                Color("bgColor.intertwinedFate.2"),
                Color("bgColor.intertwinedFate.3"),
            ]
        default:
            return []
        }
    }
}
