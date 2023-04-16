//
//  ErrorView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  Widget配置有误View

import HBMihoyoAPI
import SwiftUI

struct WidgetErrorView: View {
    let error: FetchError
    let message: String

    var body: some View {
        Text(error.description)
            .font(.title3)
            .foregroundColor(.gray)
            .padding()
    }
}
