//
//  TextPlayerView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/6.
//  展示文字信息的View

import SwiftUI

struct TextPlayerView: View {
    var title: String
    var text: String
    var nvTitle: String?

    var body: some View {
        List {
            Section(header: Text(title)) {
                Text(text)
            }
        }
        .navigationBarTitle(nvTitle ?? title, displayMode: .inline)
    }
}
