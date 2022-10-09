//
//  LatestVersionInfoView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/9/27.
//

import SwiftUI

struct LatestVersionInfoView: View {
    @Binding var sheetType: ContentViewSheetType?
    @Binding var newestVersionInfos: NewestVersion?
    @Binding var isJustUpdated: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text(newestVersionInfos?.shortVersion ?? "Error").font(.largeTitle) +
                    Text(" (\(newestVersionInfos?.buildVersion ?? -1))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image("AppIconHD")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                }
                Divider()
                    .padding(.vertical)
                Text("更新内容：")
                    .font(.subheadline)
                if newestVersionInfos != nil {
                    ForEach(getLocalizedUpdateInfos(meta: newestVersionInfos!), id:\.self) { item in
                        Text("- \(item)")
                    }
                } else {
                    Text("Error")
                }
                if !isJustUpdated {
                    switch AppConfig.appConfiguration {
                    case .TestFlight, .Debug :
                        Link (destination: URL(string: "itms-beta://beta.itunes.apple.com/v1/app/1635319193")!) {
                            Text("前往TestFlight更新")
                        }
                        .padding(.top)
                    case .AppStore:
                        Link (destination: URL(string: "itms-apps://apps.apple.com/us/app/id1635319193")!) {
                            Text("前往App Store更新")
                        }
                        .padding(.top)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle(isJustUpdated ? "感谢您更新到最新版本" : "发现新版本")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        var checkedUpdateVersions = UserDefaults.standard.object(forKey: "checkedUpdateVersions") as? [Int] ?? []
                        checkedUpdateVersions.append(newestVersionInfos!.buildVersion)
                        UserDefaults.standard.set(checkedUpdateVersions, forKey: "checkedUpdateVersions")
                        UserDefaults.standard.synchronize()
                        sheetType = nil
                    }
                }
            }
        }
    }

    func getLocalizedUpdateInfos(meta: NewestVersion) -> [String] {
        switch Locale.current.languageCode {
        case "zh":
            return meta.updates.zhcn
        case "en":
            return meta.updates.en
        case "ja":
            return meta.updates.ja
        case "fr":
            return meta.updates.fr
        default:
            return meta.updates.en
        }
    }
}
