//
//  GuideVideoLinkView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/9/6.
//

import SwiftUI

struct GuideVideoLinkView: View {
    var body: some View {
        List {
            Section(header: Text("中文")) {
                Link(destination: (isInstallation(urlString: "bilibili://") ? URL(string: "bilibili://video/BV1Lg411S7wa")! : URL(string: "https://www.bilibili.com/video/BV1Lg411S7wa"))!) {
                    Label {
                        Text("打开Bilibili观看")
                    } icon: {
                        Image("bilibili")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
                Link(destination: URL(string: "https://www.youtube.com/watch?v=k9G2N8XYFm4")!) {
                    Label {
                        Text("打开YouTube观看")
                    } icon: {
                        Image("youtube")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
            }
            Section(header: Text("English")) {
                Link(destination: URL(string: "https://www.youtube.com/watch?v=ox4RZ1VVu18")!) {
                    Label {
                        Text("打开YouTube观看")
                    } icon: {
                        Image("youtube")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
                Link(destination: (isInstallation(urlString: "bilibili://") ? URL(string: "bilibili://video/BV1BG4y167Dr")! : URL(string: "https://www.bilibili.com/video/BV1BG4y167Dr"))!) {
                    Label {
                        Text("打开Bilibili观看")
                    } icon: {
                        Image("bilibili")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
            }
            Section(header: Text("日本語")) {
                Link(destination: URL(string: "https://www.youtube.com/watch?v=ceSLVHhBpJI")!) {
                    Label {
                        Text("打开YouTube观看")
                    } icon: {
                        Image("youtube")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
                Link(destination: (isInstallation(urlString: "bilibili://") ? URL(string: "bilibili://video/BV1Re4y1d7a6")! : URL(string: "https://www.bilibili.com/video/BV1Re4y1d7a6"))!) {
                    Label {
                        Text("打开Bilibili观看")
                    } icon: {
                        Image("bilibili")
                            .resizable()
                            .foregroundColor(.blue)
                            .scaledToFit()
                    }
                }
            }
        }
        .navigationBarTitle("App介绍视频")
        .navigationBarTitleDisplayMode(.inline)
    }

    func isInstallation(urlString:String?) -> Bool {
            let url = URL(string: urlString!)
            if url == nil {
                return false
            }
            if UIApplication.shared.canOpenURL(url!) {
                return true
            }
            return false
        }
}
