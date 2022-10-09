//
//  UpdateHistoryInfoView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/10/2.
//

import SwiftUI

struct UpdateHistoryInfoView: View {
    @State private var newestVersionInfos: NewestVersion? = nil
    @State var isJustUpdated: Bool = false
    let buildVersion = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!

    var body: some View {
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
                    .onAppear(perform: checkNewestVersion)
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
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: checkNewestVersion)
    }

    func checkNewestVersion() {
        DispatchQueue.global(qos: .default).async {
            switch AppConfig.appConfiguration {
            case .AppStore:
                API.HomeAPIs.fetchNewestVersion(isBeta: false) { result in
                    self.newestVersionInfos = result
                    guard let newestVersionInfos = newestVersionInfos else {
                        return
                    }
                    if buildVersion >= newestVersionInfos.buildVersion {
                        isJustUpdated = true
                    }
                }
            case .Debug, .TestFlight:
                API.HomeAPIs.fetchNewestVersion(isBeta: true) { result in
                    self.newestVersionInfos = result
                    guard let newestVersionInfos = newestVersionInfos else {
                        return
                    }
                    if buildVersion >= newestVersionInfos.buildVersion {
                        isJustUpdated = true
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
