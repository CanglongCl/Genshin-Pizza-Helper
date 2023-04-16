//
//  OverflowContentViewModifier.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/7.
//

import SwiftUI

// MARK: - OverflowHideIndexTabViewStyleModifier

struct OverflowHideIndexTabViewStyleModifier: ViewModifier {
    // MARK: Internal

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .background(
                    GeometryReader { contentGeometry in
                        Color.clear.onAppear {
                            contentOverflow = contentGeometry.size
                                .height > geometry
                                .size.height * 0.9
                        }
                    }
                )
                .tabViewStyle(.page(
                    indexDisplayMode: contentOverflow ? .never :
                        .always
                ))
        }
    }

    // MARK: Private

    @State
    private var contentOverflow: Bool = false
}

extension View {
    func overflowHideIndexTabViewStyle() -> some View {
        modifier(OverflowHideIndexTabViewStyleModifier())
    }
}
