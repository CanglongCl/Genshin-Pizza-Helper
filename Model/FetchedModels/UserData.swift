//
//  UserData.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  小组件和主页用到的各类数据和处理工具

import Foundation

struct UserData: Codable, Equatable, SimplifiedUserDataContainer {
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.accountName == rhs.accountName
    }

    init(
        accountName: String,

        // 用于测试和提供小组件预览视图的默认数据
        currentResin: Int,
        maxResin: Int,
        resinRecoveryTime: String,

        finishedTaskNum: Int,
        totalTaskNum: Int,
        isExtraTaskRewardReceived: Bool,

        remainResinDiscountNum: Int,
        resinDiscountNumLimit: Int,

        currentExpeditionNum: Int,
        maxExpeditionNum: Int,
        expeditions: [Expedition],

        currentHomeCoin: Int,
        maxHomeCoin: Int,
        homeCoinRecoveryTime: String,

        transformer: TransformerData
    ) {
        self.accountName = accountName

        self.currentResin = currentResin
        self.maxResin = maxResin
        self.resinRecoveryTime = resinRecoveryTime

        self.finishedTaskNum = finishedTaskNum
        self.totalTaskNum = totalTaskNum
        self.isExtraTaskRewardReceived = isExtraTaskRewardReceived

        self.remainResinDiscountNum = remainResinDiscountNum
        self.resinDiscountNumLimit = resinDiscountNumLimit

        self.currentExpeditionNum = currentExpeditionNum
        self.maxExpeditionNum = maxExpeditionNum
        self.expeditions = expeditions

        self.currentHomeCoin = currentHomeCoin
        self.maxHomeCoin = maxResin
        self.homeCoinRecoveryTime = homeCoinRecoveryTime

        self.transformer = transformer
    }

    var accountName: String?
    
    mutating func addName(_ name: String) { accountName = name }
    
    // 树脂
    // decode
    private let currentResin: Int
    private let maxResin: Int
    private let resinRecoveryTime: String
    
    var resinInfo: ResinInfo {
        ResinInfo(currentResin, maxResin, Int(resinRecoveryTime)!)
    }
    
    // 每日任务
    private let finishedTaskNum: Int
    private let totalTaskNum: Int
    private let isExtraTaskRewardReceived: Bool
    
    var dailyTaskInfo: DailyTaskInfo {
        DailyTaskInfo(totalTaskNum: totalTaskNum, finishedTaskNum: finishedTaskNum, isTaskRewardReceived: isExtraTaskRewardReceived)
    }
    
    // 周本
    private let remainResinDiscountNum: Int
    private let resinDiscountNumLimit: Int
    
    var weeklyBossesInfo: WeeklyBossesInfo {
        WeeklyBossesInfo(remainResinDiscountNum: remainResinDiscountNum, resinDiscountNumLimit: resinDiscountNumLimit)
    }
    
    // 派遣探索
    private let currentExpeditionNum: Int
    private let maxExpeditionNum: Int
    private let expeditions: [Expedition]
    
    var expeditionInfo: ExpeditionInfo {
        ExpeditionInfo(currentExpedition: currentExpeditionNum, maxExpedition: maxExpeditionNum, expeditions: expeditions)
    }
    
    // 洞天宝钱
    private let currentHomeCoin: Int
    private let maxHomeCoin: Int
    private let homeCoinRecoveryTime: String
    
    var homeCoinInfo: HomeCoinInfo {
        HomeCoinInfo(currentHomeCoin, maxHomeCoin, Int(homeCoinRecoveryTime)!)
    }
    
    // 参量质变仪
    private let transformer: TransformerData
    
    var transformerInfo: TransformerInfo {
        TransformerInfo(transformer)
    }
}

typealias SimplifiedUserDataResult = Result<SimplifiedUserData, FetchError>
typealias SimplifiedUserDataContainerResult<T> = Result<T, FetchError> where T: SimplifiedUserDataContainer

struct SimplifiedUserData: Codable, SimplifiedUserDataContainer {
    let resinInfo: ResinInfo
    let dailyTaskInfo: DailyTaskInfo
    let expeditionInfo: ExpeditionInfo
    let homeCoinInfo: HomeCoinInfo

    init?(widgetUserData: WidgetUserData) {
        guard let resin: String = widgetUserData.data.data.first(where: { $0.name == "原粹树脂" })?.value,
              let expedition: String = widgetUserData.data.data.first(where: { $0.name == "探索派遣"})?.value,
              let task: String = widgetUserData.data.data.first(where: { $0.name == "每日委托进度" })?.value ?? widgetUserData.data.data.first(where: { $0.name == "每日委托奖励" })?.value,
              let homeCoin: String = widgetUserData.data.data.first(where: { $0.name == "洞天财瓮" })?.value
        else { return nil }

        let resinStr = resin.split(separator: "/")
        guard let currentResin: Int = Int(resinStr.first ?? ""),
              let maxResin: Int = Int(resinStr.last ?? "")
        else { return nil }
        let resinRecoveryTime: Int = (maxResin - currentResin) * 8 * 60
        self.resinInfo = .init(currentResin, maxResin, resinRecoveryTime)

        let taskStr = task.split(separator: "/")
        if taskStr.count == 1 {
            let isTaskRewardReceived: Bool = (task != "尚未领取")
            self.dailyTaskInfo = .init(totalTaskNum: 4, finishedTaskNum: 4, isTaskRewardReceived: isTaskRewardReceived)
        } else {
            guard let finishedTaskNum = Int(taskStr.first ?? ""),
                  let totalTaskNum = Int(taskStr.last ?? "")
            else { return nil }
            let isTaskRewardReceived = (finishedTaskNum == totalTaskNum)
            self.dailyTaskInfo = .init(totalTaskNum: totalTaskNum, finishedTaskNum: finishedTaskNum, isTaskRewardReceived: isTaskRewardReceived)
        }


        let expeditionStr = expedition.split(separator: "/")
        guard let currentExpeditionNum = Int(expeditionStr.first ?? ""),
              let maxExpeditionNum = Int(expeditionStr.last ?? "")
        else { return nil }
        self.expeditionInfo = .init(currentExpedition: currentExpeditionNum, maxExpedition: maxExpeditionNum, expeditions: [])

        let homeCoinStr = homeCoin.split(separator: "/")
        if homeCoinStr.count == 1 {
            self.homeCoinInfo = .init(0, 300, 0)
        } else {
            guard let currentHomeCoin = Int(homeCoinStr.first ?? ""),
                  let maxHomeCoin = Int(homeCoinStr.last ?? "")
            else { return nil }
            if UserDefaults(suiteName: "group.GenshinPizzaHelper")?.double(forKey: "homeCoinRefreshFrequencyInHour") == 0 {
                UserDefaults(suiteName: "group.GenshinPizzaHelper")!.set(30.0, forKey: "homeCoinRefreshFrequencyInHour")
            }
            var homeCoinRefreshFrequencyInHour: Int = Int(UserDefaults(suiteName: "group.GenshinPizzaHelper")?.double(forKey: "homeCoinRefreshFrequencyInHour") ?? 30.0)
            // 我也不知道为什么有时候这玩意取到0，反正给个默认值30吧
            homeCoinRefreshFrequencyInHour = !(4...30).contains(homeCoinRefreshFrequencyInHour) ? 30 : homeCoinRefreshFrequencyInHour
            let homeCoinRecoveryHour: Int = (maxHomeCoin - currentHomeCoin) / homeCoinRefreshFrequencyInHour
            let homeCoinRecoverySecond: Int = homeCoinRecoveryHour * 60 * 60
            self.homeCoinInfo = .init(currentHomeCoin, maxHomeCoin, homeCoinRecoverySecond)
        }
    }
}

extension UserData {
    static let defaultData = UserData(
        accountName: "荧",
        
        // 用于测试和提供小组件预览视图的默认数据
        currentResin: 90,
        maxResin: 160,
        resinRecoveryTime: "\((160-90)*8)",

        finishedTaskNum: 3,
        totalTaskNum: 4,
        isExtraTaskRewardReceived: false,

        remainResinDiscountNum: 2,
        resinDiscountNumLimit: 3,

        currentExpeditionNum: 2,
        maxExpeditionNum: 5,
        expeditions: Expedition.defaultExpeditions,

        currentHomeCoin: 1200,
        maxHomeCoin: 2400,
        homeCoinRecoveryTime: "123",
        
        transformer: TransformerData(recoveryTime: TransformerData.TransRecoveryTime(day: 4, hour: 3, minute: 0, second: 0), obtained: true)
    )
}

extension Expedition {
    static let defaultExpedition: Expedition = Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Sara.png", remainedTimeStr: "0", statusStr: "Finished")

    static let defaultExpeditions: [Expedition] = [Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Yelan.png", remainedTimeStr: "0", statusStr: "Finished"),
    Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Fischl.png", remainedTimeStr: "37036", statusStr: "Ongoing"),
    Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Fischl.png", remainedTimeStr: "22441", statusStr: "Ongoing"),
    Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Keqing.png", remainedTimeStr: "22441", statusStr: "Ongoing"),
    Expedition(avatarSideIcon: "https://upload-bbs.mihoyo.com/game_record/genshin/character_side_icon/UI_AvatarIcon_Side_Bennett.png", remainedTimeStr: "22441", statusStr: "Ongoing")]
}

protocol SimplifiedUserDataContainer {
    var resinInfo: ResinInfo { get }
    var homeCoinInfo: HomeCoinInfo { get }
    var expeditionInfo: ExpeditionInfo { get }
    var dailyTaskInfo: DailyTaskInfo { get }
}
