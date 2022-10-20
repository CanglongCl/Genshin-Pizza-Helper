//
//  ThisDevice.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/7.
//

import SwiftUI

struct ThisDevice {
    private init () {}

    static var notchType: NotchType {
        if hasDynamicIsland {
            return .dynamicIsland
        } else if hasNormalNotch {
            return .normalNotch
        } else {
            return .none
        }
    }

    static var hasDynamicIsland: Bool {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 59
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }

    static var hasNormalNotch: Bool {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44 && window.safeAreaInsets.top < 59
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }

    enum NotchType {
        case normalNotch
        case dynamicIsland
        case none
    }
}
