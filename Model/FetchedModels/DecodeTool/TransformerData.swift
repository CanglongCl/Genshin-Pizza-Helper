//
//  RecoveryTime.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//

import Foundation



struct TransformerData: Codable {
    let recoveryTime: TransRecoveryTime
    let obtained: Bool
    
    struct TransRecoveryTime: Codable {
        let day: Int
        let hour: Int
        let minute: Int
        let second: Int

        enum CodingKeys: String, CodingKey {
            case day = "Day"
            case hour = "Hour"
            case minute = "Minute"
            case second = "Second"
        }
    }
}
