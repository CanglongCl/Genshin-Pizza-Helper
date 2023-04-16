//
//  HelpSheetView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/8.
//  更多页面

import HBMihoyoAPI
import SwiftUI

// MARK: - MoreView

struct MoreView: View {
    // MARK: Internal

    var body: some View {
        List {
            Section {
                NavigationLink(destination: UpdateHistoryInfoView()) {
                    Text("检查更新")
                }
                #if DEBUG
                Button("清空已检查的版本号") {
                    UserDefaults.standard.set(
                        [],
                        forKey: "checkedUpdateVersions"
                    )
                    UserDefaults.standard.set(
                        0,
                        forKey: "checkedNewestVersion"
                    )
                    UserDefaults.standard.synchronize()
                }
                #endif
            }
            Section {
                Picker("时区", selection: $defaultServer) {
                    ForEach(Server.allCases) { server in
                        Text(server.rawValue.localized).tag(server.rawValue)
                    }
                }
            } footer: {
                Text(
                    "我们会根据您所选服务器对应时区计算每日材料刷新时间。当前时区：\((Server(rawValue: defaultServer) ?? .asia).timeZone().identifier)。"
                )
            }

            Section {
                Link(
                    "获取Cookie的脚本",
                    destination: URL(
                        string: "https://www.icloud.com/shortcuts/fe68f22c624949c9ad8959993239e19c"
                    )!
                )
            }
            // FIXME: Proxy not implenmented
//            Section {
//                NavigationLink(destination: ProxySettingsView()) {
//                    Text("代理设置")
//                }
//            }
            Section {
                NavigationLink(
                    destination: WebBroswerView(
                        url: "https://ophelper.top/static/policy.html"
                    )
                    .navigationTitle("用户协议")
                ) {
                    Text("用户协议与免责声明")
                }
                NavigationLink(destination: AboutView()) {
                    Text("关于小助手")
                }
            }

            Section {
                Button(
                    "清空缓存 (\(String(format: "%.2f", viewModel.fileSize))MB)"
                ) {
                    viewModel.clearImageCache()
                }
            }
        }
        .navigationBarTitle("更多", displayMode: .inline)
    }

    // MARK: Private

    @ObservedObject
    private var viewModel: MoreViewCacheViewModel = .init()

    @AppStorage(
        "defaultServer",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var defaultServer: String = Server.asia.rawValue
}

// MARK: - MoreViewCacheViewModel

class MoreViewCacheViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        do {
            let fileUrls = try FileManager.default
                .contentsOfDirectory(atPath: imageFolderURL.path)
            self.fileSize = 0.0
            for fileUrl in fileUrls {
                let attributes = try FileManager.default
                    .attributesOfItem(
                        atPath: imageFolderURL
                            .appendingPathComponent(fileUrl).path
                    )
                fileSize += attributes[FileAttributeKey.size] as! Double
            }
            self.fileSize = fileSize / 1024.0 / 1024.0
        } catch {
            print("error get images size: \(error)")
            self.fileSize = 0.0
        }
    }

    // MARK: Internal

    let imageFolderURL = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!.appendingPathComponent("Images")
    @Published
    var fileSize: Double

    func clearImageCache() {
        do {
            let fileUrls = try FileManager.default
                .contentsOfDirectory(atPath: imageFolderURL.path)
            for fileUrl in fileUrls {
                try FileManager.default
                    .removeItem(
                        at: imageFolderURL
                            .appendingPathComponent(fileUrl)
                    )
            }
            fileSize = 0.0
            print("Image Cache Cleared!")
        } catch {
            print("error: Image Cache Clear:\(error)")
        }
    }
}
