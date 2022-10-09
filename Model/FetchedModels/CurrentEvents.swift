//
//  CurrentEvents.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/17.
//

import Foundation

struct CurrentEvent: Codable {
    var event: [String: EventModel]

    struct EventKey: CodingKey {
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
        let container = try decoder.container(keyedBy: EventKey.self)

        var events = [String: EventModel]()
        for key in container.allKeys {
            if let model = try? container.decode(EventModel.self, forKey: key) {
                events[key.stringValue] = model
            }
        }
        self.event = events
    }
}

struct EventModel: Codable {
    var id: Int
    var name: MultiLanguageContents
    var nameFull: MultiLanguageContents
    var description: MultiLanguageContents
    var banner: MultiLanguageContents
    var endAt: String

    struct MultiLanguageContents: Codable {
        var EN: String
        var RU: String
        var CHS: String
        var CHT: String
        var KR: String
        var JP: String
    }
}
