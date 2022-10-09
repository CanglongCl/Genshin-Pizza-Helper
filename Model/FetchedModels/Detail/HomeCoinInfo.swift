//
//  HomeCoinInfo.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  洞天宝钱信息

import Foundation

struct HomeCoinInfo {
    
    let currentHomeCoin: Int
    let maxHomeCoin: Int
    let recoveryTime: RecoveryTime
    
    var isFull: Bool { recoveryTime.isComplete }
    
    var percentage: Double { Double(currentHomeCoin) / Double(maxHomeCoin) }
    
    init(_ currentHomeCoin: Int, _ maxHomeCoin: Int, _ homeCoinRecoverySecond: Int) {
        self.currentHomeCoin = currentHomeCoin
        self.maxHomeCoin = maxHomeCoin
        self.recoveryTime = RecoveryTime(second: homeCoinRecoverySecond)
    }

    var score: Float {
        if percentage > 0.7 {
            return Float(percentage)
        } else { return 0 }
    }
}
