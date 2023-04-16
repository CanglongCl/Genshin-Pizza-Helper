//
//  HiddenWaterMark.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/7.
//

import SwiftUI

// MARK: - HiddenWaterMark

@available(iOS 15.0, *)
struct HiddenWaterMark: ViewModifier {
    func body(content: Content) -> some View {
        let waterMarkWithName = HStack {
            Image("AppIconHD")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                ))
            Text("披萨小助手").font(.footnote).bold()
        }
        .frame(maxWidth: 270, maxHeight: 20)
        switch ThisDevice.notchType {
        case .dynamicIsland:
            content.overlay(alignment: .top) {
                waterMarkWithName.padding(.top, 15)
            }
        case .normalNotch:
            content.overlay(alignment: .top) {
                waterMarkWithName.padding(.top, 10)
            }
        case .none:
            content
        }
    }
}

@available(iOS 15.0, *)
extension View {
    func hiddenWaterMark() -> some View {
        modifier(HiddenWaterMark())
    }
}
