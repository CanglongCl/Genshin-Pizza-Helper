//
//  ThanksView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/9/18.
//

import SwiftUI

struct ThanksView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("我们的App使用了以下开源组件和第三方API，在此向其作者表示感谢。")
                .font(.footnote)
            Divider()
            Group {
                Text("SwiftPieChart - Nazar Ilamanov\nhttps://github.com/ilamanov/SwiftPieChart")
            }
            .font(.caption)
            Divider()
            Group {
                Text("Game Account Data API - 米游社 (CN) / HoYoLAB (OS)")
                Text("Events API - Project Amber (https://ambr.top)")
                Text("Character Showcase API - Enka Network (https://enka.network)")
                Text("Genshin Dictionary API - Genshin Dictionary (https://genshin-dictionary.com)")
            }
            .font(.caption)
            Spacer()
        }
        .padding()
        .navigationTitle("开源组件与第三方API致谢")
    }
}
