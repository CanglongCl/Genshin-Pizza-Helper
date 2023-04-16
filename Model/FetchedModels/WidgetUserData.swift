//
//  File.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/11/14.
//

import Foundation

struct WidgetUserData: Codable {
    struct WidgetUserDataDetail: Codable {
        struct DetailData: Codable {
            var name: String
            var type: String
            var value: String
        }

        var region: String
        var gameRoleId: String
        var backgroundImage: String
        var nickname: String
        var data: [DetailData]
        var gameId: Int
        var level: Int
        var regionName: String
    }

    var data: WidgetUserDataDetail
}
