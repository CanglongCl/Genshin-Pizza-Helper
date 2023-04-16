//
//  PrivacySettingsView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/10/16.
//

import SwiftUI

struct PrivacySettingsView: View {
    @AppStorage("allowAbyssDataCollection")
    var allowAbyssDataCollection: Bool =
        false

    var body: some View {
        List {
            Section {
                Toggle(isOn: $allowAbyssDataCollection) {
                    Text("允许收集深渊数据")
                }
            } footer: {
                Text(
                    "我们希望收集您已拥有的角色和在攻克深渊时使用的角色。如果您同意我们使用您的数据，您将可以在App内查看我们实时汇总的深渊角色使用率、队伍使用率等情况。您的隐私非常重要，我们不会收集包括UID在内的敏感信息。更多相关问题，请查看深渊统计榜单页面右上角的FAQ."
                )
            }
        }
        .navigationBarTitle("隐私设置", displayMode: .inline)
    }
}
