//
//  ENCharacterMapModel.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import Foundation

struct ENCharacterMap: Codable {
    var characterDetails: [String: Character]

    struct CharacterKey: CodingKey {
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
        let container = try decoder.container(keyedBy: CharacterKey.self)

        var character = [String: Character]()
        for key in container.allKeys {
            if let model = try? container.decode(Character.self, forKey: key) {
                character[key.stringValue] = model
            }
        }
        self.characterDetails = character
    }

    struct Character: Codable {
        var Element: String
        var Consts: [String]
        var SkillOrder: [Int]
        var Skills: Skill
        var ProudMap: ProudMap
        var NameTextMapHash: Int
        var SideIconName: String
        var QualityType: String

        struct Skill: Codable {
            var skillData: [String: String]

            struct SkillKey: CodingKey {
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
                let container = try decoder.container(keyedBy: SkillKey.self)

                var skill = [String: String]()
                for key in container.allKeys {
                    if let model = try? container.decode(String.self, forKey: key) {
                        skill[key.stringValue] = model
                    }
                }
                self.skillData = skill
            }
        }

        struct ProudMap: Codable {
            var proudMapData: [String: Int]

            struct ProudKey: CodingKey {
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
                let container = try decoder.container(keyedBy: ProudKey.self)

                var proud = [String: Int]()
                for key in container.allKeys {
                    if let model = try? container.decode(Int.self, forKey: key) {
                        proud[key.stringValue] = model
                    }
                }
                self.proudMapData = proud
            }
        }
    }
}
