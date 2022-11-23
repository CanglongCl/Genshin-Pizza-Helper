//
//  SwiftUIView.swift
//  ResinStatusWidgetExtension
//
//  Created by 戴藏龙 on 2022/11/14.
//

import SwiftUI
import WidgetKit

struct MainWidgetSimplifiedView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var userData: SimplifiedUserData
    let viewConfig: WidgetViewConfiguration
    let accountName: String?

    var body: some View {
        switch family {
        case .systemSmall:
            MainInfoSimplified(userData: userData, viewConfig: viewConfig, accountName: viewConfig.showAccountName ? accountName : nil)
                .padding()
        case .systemMedium:
            MainInfoWithDetailSimplified(userData: userData, viewConfig: viewConfig, accountName: viewConfig.showAccountName ? accountName : nil)
        case .systemLarge:
            LargeWidgetViewSimplified(userData: userData, viewConfig: viewConfig, accountName: viewConfig.showAccountName ? accountName : nil)
        default:
            MainInfoWithDetailSimplified(userData: userData, viewConfig: viewConfig, accountName: viewConfig.showAccountName ? accountName : nil)
        }
    }
}
