//
//  WatchAccountDetailItemView.swift
//  WatchHelper WatchKit Extension
//
//  Created by Bill Haku on 2022/9/9.
//

import SwiftUI

struct WatchAccountDetailItemView: View {
    var title: String
    var value: String
    var icon: Image?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = icon {
                    icon
                        .resizable()
                        .frame(width: 15, height: 15)
                        .scaledToFit()
                }
                Text(LocalizedStringKey(title))
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
            Text(value)
        }
    }
}
