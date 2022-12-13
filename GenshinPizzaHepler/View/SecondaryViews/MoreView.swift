//
//  HelpSheetView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/8.
//  更多页面

import SwiftUI

struct MoreView: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: UpdateHistoryInfoView()) {
                    Text("检查更新")
                }
                #if DEBUG
                Button("清空已检查的版本号") {
                    UserDefaults.standard.set([], forKey: "checkedUpdateVersions")
                    UserDefaults.standard.set(0, forKey: "checkedNewestVersion")
                    UserDefaults.standard.synchronize()
                }
                #endif
            }
            Section {
                Link("获取Cookie的脚本", destination: URL(string: "https://www.icloud.com/shortcuts/fe68f22c624949c9ad8959993239e19c")!)
            }
            // FIXME: Proxy not implenmented
//            Section {
//                NavigationLink(destination: ProxySettingsView()) {
//                    Text("代理设置")
//                }
//            }
            Section {
                NavigationLink(destination: WebBroswerView(url: "http://ophelper.top/static/policy.html").navigationTitle("用户协议")) {
                    Text("用户协议与免责声明")
                }
                NavigationLink(destination: AboutView()) {
                    Text("关于小助手")
                }
            }
        }
        .navigationBarTitle("更多", displayMode: .inline)
    }
}
