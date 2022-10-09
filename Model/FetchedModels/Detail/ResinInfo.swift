//
//  ResinInfo.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  树脂信息

import Foundation

struct ResinInfo {
    let currentResin: Int
    let maxResin: Int
    private let resinRecoverySecond: Int
    
    var isFull: Bool { currentResin == maxResin }
    
    var recoveryTime: RecoveryTime {
        RecoveryTime(second: resinRecoverySecond)
    }
    
    var percentage: Double { Double(currentResin) / Double(maxResin) }
    
    init(_ currentResin: Int, _ maxResin: Int, _ resinRecoverySecond: Int) {
        self.currentResin = currentResin
        self.maxResin = maxResin
        self.resinRecoverySecond = resinRecoverySecond
    }

    var score: Float {
        if isFull { return 1.1 }
        return Float(percentage)
    }
}
