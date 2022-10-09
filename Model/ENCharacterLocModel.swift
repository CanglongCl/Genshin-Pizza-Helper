//
//  ENCharacterLocModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import Foundation

struct ENCharacterLoc: Codable {
    var en: LocDict
    var ru: LocDict
    var vi: LocDict
    var th: LocDict
    var pt: LocDict
    var ko: LocDict
    var ja: LocDict
    var id: LocDict
    var fr: LocDict
    var es: LocDict
    var de: LocDict
    var zh_tw: LocDict
    var zh_cn: LocDict

    struct LocDict: Codable {
        var content: [String: String]

        struct LocKey: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.stringValue = "\(intValue)"
                self.intValue = intValue
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: LocKey.self)

            var contentDict = [String: String]()
            for key in container.allKeys {
                if let model = try? container.decode(String.self, forKey: key) {
                    contentDict[key.stringValue] = model
                }
            }
            self.content = contentDict
        }
    }

    private enum CodingKeys: String, CodingKey {
        case en, ru, vi, th, pt, ko, ja, id, fr, es, de
        case zh_tw = "zh-TW"
        case zh_cn = "zh-CN"
    }
}
