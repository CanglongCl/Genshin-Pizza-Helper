//
//  MainInfoWithDetailView.swift
//  ResinStatusWidgetExtension
//
//  Created by Bill Haku on 2022/8/6.
//  中号Widget布局

import Foundation
import SwiftUI

struct MainInfoWithDetail: View {
    let userData: UserData
    let viewConfig: WidgetViewConfiguration
    let accountName: String?

    var body: some View {
        HStack {
            Spacer()
            MainInfo(userData: userData, viewConfig: viewConfig, accountName: accountName)
                .padding()
            Spacer()
            DetailInfo(userData: userData, viewConfig: viewConfig)
                .padding([.vertical])
                .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
            Spacer()
        }
    }
}

struct MainInfoWithDetailSimplified: View {
    let userData: SimplifiedUserData
    let viewConfig: WidgetViewConfiguration
    let accountName: String?

    var body: some View {
        HStack {
            Spacer()
            MainInfoSimplified(userData: userData, viewConfig: viewConfig, accountName: accountName)
                .padding()
            Spacer()
            DetailInfoSimplified(userData: userData, viewConfig: viewConfig)
                .padding([.vertical])
                .frame(maxWidth: UIScreen.main.bounds.width / 8 * 3)
            Spacer()
        }
    }
}
