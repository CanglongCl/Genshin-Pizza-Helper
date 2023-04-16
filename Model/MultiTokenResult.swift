//
//  MultiTokenResult.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/15.
//

import Foundation

// MARK: - MultiTokenResult

struct MultiTokenResult: Codable {
    let retcode: Int
    let message: String
    let data: MultiToken?
}

// MARK: - MultiToken

struct MultiToken: Codable {
    struct Item: Codable {
        let name: String
        let token: String
    }

    var list: [Item]

    var stoken: String {
        list.first { item in
            item.name == "stoken"
        }?.token ?? ""
    }

    var ltoken: String {
        list.first { item in
            item.name == "ltoken"
        }?.token ?? ""
    }
}
