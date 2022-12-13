//
//  TestView.swift
//  原神披萨小助手
//
//  Created by 戴藏龙 on 2022/8/8.
//  测试连接部分的View

import SwiftUI

struct TestSectionView: View {
    @Binding var connectStatus: ConnectStatus
    
    @Binding var uid: String
    @Binding var cookie: String
    @Binding var server: Server

    @State private var error: FetchError? = nil

    @State private var is1034WebShown: Bool = false
    
    var body: some View {
        Section {
            Button(action: {
                connectStatus = .testing
            }) {
                HStack {
                    Text("测试连接")
                    Spacer()
                    switch connectStatus {
                    case .unknown:
                        Text("")
                    case .success:
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    case .fail:
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    case .testing:
                        ProgressView()
                    }
                }
            }
            if connectStatus == .fail {
                InfoPreviewer(title: "错误内容", content: error?.description ?? "")
                InfoPreviewer(title: "DEBUG", content: error?.message ?? "")
                    .foregroundColor(.gray)
                if let error = error {
                    switch error {
                    case .accountAbnormal(_):
                        Section {
                            let mihoyobbsURLString: String = "mihoyobbs://"
                            if isInstallation(urlString: mihoyobbsURLString) {
                                if let url = URL(string: mihoyobbsURLString) {
                                    Link(destination: url) {
                                        Text("点击打开米游社App")
                                    }
                                }
                            } else {
                                if let url = URL(string: "https://apps.apple.com/cn/app/id1470182559") {
                                    Link(destination: url) {
                                        Text("点击打开米游社App")
                                    }
                                }
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
            if connectStatus == .success {
                if !cookie.contains("stoken") && server.region == .cn {
                    Label {
                        Text("本账号无stoken，可能影响简洁模式下小组件使用。建议重新登陆以获取stoken。")
                    } icon: {
                        Image(systemName: "checkmark.circle.trianglebadge.exclamationmark")
                            .foregroundColor(.red)
                    }
                }
            }
        } footer: {
            if let error = error {
                switch error {
                case .accountAbnormal(_):
                    Button("反复出现账号异常？点击查看解决方案") {
                        is1034WebShown.toggle()
                    }
                    .font(.footnote)
                default:
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $is1034WebShown, content: {
            NavigationView {
                WebBroswerView(url: "http://ophelper.top/static/1034_error_soution")
                    .dismissableSheet(isSheetShow: $is1034WebShown)
                    .navigationTitle("1034问题的解决方案")
                    .navigationBarTitleDisplayMode(.inline)
            }
        })
        .onAppear {
            if connectStatus == .testing {
                API.Features.fetchInfos(region: server.region,
                                        serverID: server.id,
                                        uid: uid,
                                        cookie: cookie)
                { result in
                    switch result {
                    case .success( _):
                        connectStatus = .success
                    case .failure(let error):
                        connectStatus = .fail
                        self.error = error
                    }
                }
            }
        }
        .onChange(of: connectStatus) { newValue in
            if newValue == .testing {
                API.Features.fetchInfos(region: server.region,
                                        serverID: server.id,
                                        uid: uid,
                                        cookie: cookie)
                { result in
                    switch result {
                    case .success( _):
                        connectStatus = .success
                    case .failure(let error):
                        connectStatus = .fail
                        self.error = error
                    }
                }
            }
        }
    }

    func isInstallation(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        } else {
            return false
        }
    }
}


