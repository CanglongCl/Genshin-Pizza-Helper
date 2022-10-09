//
//  ProxySettingsView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/5.
//

import SwiftUI

struct ProxySettingsView: View {
    @AppStorage("useProxy", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var useProxy: Bool = false
    @AppStorage("proxyHost", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var proxyHost: String = ""
    @AppStorage("proxyPort", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var proxyPort: String = ""
    @AppStorage("proxyUserName", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var proxyUserName: String = ""
    @AppStorage("proxyUserPassword", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var proxyPassword: String = ""

    var body: some View {
        List {
            Section {
                Toggle("启用代理", isOn: $useProxy)
            }
            Section (header: Text("代理配置")) {
                InfoEditor(title: "服务器", content: $proxyHost)
                InfoEditor(title: "端口", content: $proxyPort, keyboardType: .numberPad)
            }
            Section (header: Text("认证信息（可选）")) {
                InfoEditor(title: "用户名", content: $proxyUserName)
                InfoEditor(title: "密码", content: $proxyPassword)
            }
        }
        .navigationTitle("代理设置")
    }
}
