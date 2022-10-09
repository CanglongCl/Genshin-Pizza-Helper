//
//  OptionalAccounts.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/16.
//  可选帐号

import Foundation

struct RequestAccountListResult: Codable {
    let retcode: Int
    let message: String
    let data: AccountListData?
}

struct AccountListData: Codable {
    let list: [FetchedAccount]
}

struct FetchedAccount: Codable, Hashable, Identifiable {
    let region: String
    let gameBiz: String
    let nickname: String
    let level: Int
    let isOfficial: Bool
    let regionName: String
    let gameUid: String
    let isChosen: Bool
    
    var id: String { gameUid }
}
