//
//  ExpeditionsView.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/23.
//  探索派遣View

import SwiftUI

struct ExpeditionsView: View {
    let expeditions: [Expedition]
    var useAsyncImage: Bool = false

    var body: some View {
        VStack {
            ForEach(expeditions, id: \.charactersEnglishName) { expedition in
                EachExpeditionView(expedition: expedition, useAsyncImage: useAsyncImage)
                if expedition.charactersEnglishName != (expeditions.last?.charactersEnglishName ?? "") {
                    Spacer()
                }
            }
        }
//        .background(WidgetBackgroundView(background: .randomNamecardBackground, darkModeOn: true))
    }
}


