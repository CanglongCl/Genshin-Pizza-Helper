//
//  UserData.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  小组件和主页用到的各类数据和处理工具

import Foundation

struct UserData: SimplifiedUserDataContainer {

    init(fetchData: FetchData) {
        resinInfo = ResinInfo(fetchData.currentResin, fetchData.maxResin, Int(fetchData.resinRecoveryTime)!)
        dailyTaskInfo = DailyTaskInfo(totalTaskNum: fetchData.totalTaskNum, finishedTaskNum: fetchData.finishedTaskNum, isTaskRewardReceived: fetchData.isExtraTaskRewardReceived)
        weeklyBossesInfo = WeeklyBossesInfo(remainResinDiscountNum: fetchData.remainResinDiscountNum, resinDiscountNumLimit: fetchData.resinDiscountNumLimit)
        expeditionInfo = ExpeditionInfo(currentExpedition: fetchData.currentExpeditionNum, maxExpedition: fetchData.maxExpeditionNum, expeditions: fetchData.expeditions)
        homeCoinInfo = HomeCoinInfo(fetchData.currentHomeCoin, fetchData.maxHomeCoin, Int(fetchData.homeCoinRecoveryTime)!)
        transformerInfo = TransformerInfo(fetchData.transformer)
    }

    init(resinInfo: ResinInfo, dailyTaskInfo: DailyTaskInfo, weeklyBossesInfo: WeeklyBossesInfo, expeditionInfo: ExpeditionInfo, homeCoinInfo: HomeCoinInfo, transformerInfo: TransformerInfo) {
        self.resinInfo = resinInfo
        self.dailyTaskInfo = dailyTaskInfo
        self.weeklyBossesInfo = weeklyBossesInfo
        self.expeditionInfo = expeditionInfo
        self.homeCoinInfo = homeCoinInfo
        self.transformerInfo = transformerInfo
    }

    let resinInfo: ResinInfo
    
    let dailyTaskInfo: DailyTaskInfo

    let weeklyBossesInfo: WeeklyBossesInfo
    
    let expeditionInfo: ExpeditionInfo

    let homeCoinInfo: HomeCoinInfo
    
    let transformerInfo: TransformerInfo
}

typealias SimplifiedUserDataResult = Result<SimplifiedUserData, FetchError>
typealias SimplifiedUserDataContainerResult<T> = Result<T, FetchError> where T: SimplifiedUserDataContainer

struct SimplifiedUserData: Codable, SimplifiedUserDataContainer {
    let resinInfo: ResinInfo
    let dailyTaskInfo: DailyTaskInfo
    let expeditionInfo: ExpeditionInfo
    let homeCoinInfo: HomeCoinInfo

    init(resinInfo: ResinInfo, dailyTaskInfo: DailyTaskInfo, expeditionInfo: ExpeditionInfo, homeCoinInfo: HomeCoinInfo) {
        self.resinInfo = resinInfo
        self.dailyTaskInfo = dailyTaskInfo
        self.expeditionInfo = expeditionInfo
        self.homeCoinInfo = homeCoinInfo
    }

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
        fetchData: FetchData(
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

    func dataAfter(_ second: TimeInterval) -> Self
}

extension UserData {
    func dataAfter(_ second: TimeInterval) -> UserData {
        guard second != 0 else {
            return self
        }
        var resinRecoveryTime = self.resinInfo.recoveryTime.second - Int(second)
        if resinRecoveryTime < 0 { resinRecoveryTime = 0 }
        var currentResin = 160 - Int(ceil(Double(resinRecoveryTime) / (8.0 * 60.0)))
        if currentResin < 0 { currentResin = 0 }


        let currentExpeditionNum: Int = self.expeditionInfo.expeditions.filter { expedition in
            Double(expedition.remainedTimeStr)! - second > 0
        }.count
        let expeditions: [Expedition] = self.expeditionInfo.expeditions.map { expedition in
            var remainTime: Int = expedition.recoveryTime.second - Int(second)
            if remainTime < 0 { remainTime = 0 }
            return .init(avatarSideIcon: expedition.avatarSideIcon, remainedTimeStr: String(remainTime), statusStr: expedition.statusStr)
        }

        let totalTime: Double
        if self.homeCoinInfo.recoveryTime.second == 0 {
            totalTime = 0
        } else {
            totalTime = Double(self.homeCoinInfo.recoveryTime.second) / (1.0 - self.homeCoinInfo.percentage)
        }
        var remainHomeCoinTimeToFull = Double(self.homeCoinInfo.recoveryTime.second) - second
        if remainHomeCoinTimeToFull < 0 { remainHomeCoinTimeToFull = 0 }
        var currentHomeCoinPercentage: Double
        if totalTime != 0 {
            currentHomeCoinPercentage = 1 - ( remainHomeCoinTimeToFull / totalTime )
        } else {
            currentHomeCoinPercentage = 1
        }
        let currentHomeCoin: Int = Int(Double(self.homeCoinInfo.maxHomeCoin) * currentHomeCoinPercentage)
        let homeCoinRecoveryTime: Int = Int(totalTime * ( 1 - currentHomeCoinPercentage ))

        return .init(
            resinInfo: .init(currentResin, self.resinInfo.maxResin, resinRecoveryTime),
            dailyTaskInfo: self.dailyTaskInfo,
            weeklyBossesInfo: self.weeklyBossesInfo,
            expeditionInfo: .init(currentExpedition: currentExpeditionNum, maxExpedition: self.expeditionInfo.maxExpedition, expeditions: expeditions),
            homeCoinInfo: .init(currentHomeCoin, self.homeCoinInfo.maxHomeCoin, homeCoinRecoveryTime),
            transformerInfo: self.transformerInfo
        )
    }
}

extension SimplifiedUserData {
    func dataAfter(_ second: TimeInterval) -> SimplifiedUserData {
        guard second != 0 else {
            return self
        }
        var resinRecoveryTime = self.resinInfo.recoveryTime.second - Int(second)
        if resinRecoveryTime < 0 { resinRecoveryTime = 0 }
        var currentResin = 160 - Int(ceil(Double(resinRecoveryTime) / (8.0 * 60.0)))
        if currentResin < 0 { currentResin = 0 }

        let totalTime: Double
        if self.homeCoinInfo.recoveryTime.second == 0 {
            totalTime = 0
        } else {
            totalTime = Double(self.homeCoinInfo.recoveryTime.second) / (1.0 - self.homeCoinInfo.percentage)
        }
        var remainHomeCoinTimeToFull = Double(self.homeCoinInfo.recoveryTime.second) - second
        if remainHomeCoinTimeToFull < 0 { remainHomeCoinTimeToFull = 0 }
        var currentHomeCoinPercentage: Double
        if totalTime != 0 {
            currentHomeCoinPercentage = 1 - ( remainHomeCoinTimeToFull / totalTime )
        } else {
            currentHomeCoinPercentage = 1
        }
        let currentHomeCoin: Int = Int(Double(self.homeCoinInfo.maxHomeCoin) * currentHomeCoinPercentage)
        let homeCoinRecoveryTime: Int = Int(totalTime * ( 1 - currentHomeCoinPercentage ))

        return .init(
            resinInfo: .init(currentResin, self.resinInfo.maxResin, resinRecoveryTime),
            dailyTaskInfo: self.dailyTaskInfo,
            expeditionInfo: self.expeditionInfo,
            homeCoinInfo: .init(currentHomeCoin, self.homeCoinInfo.maxHomeCoin, homeCoinRecoveryTime)
        )
    }
}

struct FetchData: Codable {
    init(
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
        self.maxHomeCoin = maxHomeCoin
        self.homeCoinRecoveryTime = homeCoinRecoveryTime

        self.transformer = transformer
    }

    // 树脂
    // decode
    let currentResin: Int
    let maxResin: Int
    let resinRecoveryTime: String

    // 每日任务
    let finishedTaskNum: Int
    let totalTaskNum: Int
    let isExtraTaskRewardReceived: Bool

    // 周本
    let remainResinDiscountNum: Int
    let resinDiscountNumLimit: Int

    // 派遣探索
    let currentExpeditionNum: Int
    let maxExpeditionNum: Int
    let expeditions: [Expedition]

    // 洞天宝钱
    let currentHomeCoin: Int
    let maxHomeCoin: Int
    let homeCoinRecoveryTime: String

    // 参量质变仪
    let transformer: TransformerData
}
