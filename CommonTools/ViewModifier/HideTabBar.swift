//
//  HideToolBar.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/30.
//

import SwiftUI

struct HideTabBar: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .toolbar(.hidden, for: .tabBar)
        } else {
            content
        }
    }
}

extension View {
    func hideTabBar() -> some View {
        modifier(HideTabBar())
    }
}
