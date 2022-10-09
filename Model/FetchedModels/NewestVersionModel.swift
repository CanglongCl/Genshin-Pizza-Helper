//
//  NewestVersionModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/26.
//

import Foundation

struct NewestVersion: Codable {
    var shortVersion: String
    var buildVersion: Int
    var updates: UpdateDetails

    struct UpdateDetails: Codable {
        var en: [String]
        var zhcn: [String]
        var ja: [String]
        var fr: [String]
    }
}
