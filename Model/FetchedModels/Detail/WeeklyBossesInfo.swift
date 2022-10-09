//
//  WeeklyBossesInfo.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  周本信息

import Foundation

struct WeeklyBossesInfo {
    let remainResinDiscountNum: Int
    let resinDiscountNumLimit: Int
    var hasUsedResinDiscountNum: Int { resinDiscountNumLimit - remainResinDiscountNum }
    
    var isComplete: Bool { remainResinDiscountNum == 0 }

    var score: Float {
        if Calendar.current.isDateInWeekend(Date()) && !isComplete {
            return Float(0.5)
        } else { return 0 }
    }
}
