//
//  MultiTokenResult.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/15.
//

import Foundation

struct MultiTokenResult: Codable {
    let retcode: Int
    let message: String
    let data: MultiToken?
}

struct MultiToken: Codable {
    var list: [Item]

    struct Item: Codable {
        let name: String
        let token: String
    }

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
