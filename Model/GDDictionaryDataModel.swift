//
//  GDDictionaryDataModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/10/3.
//

import Foundation

struct GDDictionary: Codable {
    struct Variants: Codable {
        var en: [String]?
        var ja: [String]?
        var zhCN: [String]?
    }

    var en: String
    var ja: String?
    var zhCN: String?
    var pronunciationJa: String?
    var id: String
    var tags: [String]?
    var notes: String?
    var variants: Variants?
}
