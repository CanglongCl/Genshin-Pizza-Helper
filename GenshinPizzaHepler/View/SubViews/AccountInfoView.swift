//
//  AccountInfoView.swift
//  GenshinPizzaHepler
//
//  Created by Bill Haku on 2022/8/7.
//  设置页的帐号信息Block

import SwiftUI

struct AccountInfoView: View {
    var account: Account

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(account.config.name!)
                    .bold()
                    .padding(.vertical)
                if let result = account.result {
                    Spacer()
                    switch result {
                    case .failure(_):
                        Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                            .padding()
                            .foregroundColor(.red)
                    case .success(_):
                        EmptyView()
                    }
                }
            }

            HStack {
                Text("UID: \(account.config.uid!)")
                Spacer()
                Text("服务器: \(account.config.server.rawValue)")
            }
            .font(.caption)
        }
        .padding(5)
    }
}
