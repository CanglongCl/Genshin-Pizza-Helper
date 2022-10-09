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
    
    @State private var errorInfo: String = ""
    @State private var errorMessage: String = ""
    
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
                InfoPreviewer(title: "错误内容", content: errorInfo)
                InfoPreviewer(title: "DEBUG", content: errorMessage)
                    .foregroundColor(.gray)
            }
        }
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
                        errorInfo = error.description
                        errorMessage = error.message
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
                        errorInfo = error.description
                        errorMessage = error.message
                    }
                }
            }
        }
    }
}


