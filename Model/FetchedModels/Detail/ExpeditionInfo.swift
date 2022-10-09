//
//  ExpeditionDetail.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/7.
//  探索派遣信息

import Foundation

struct ExpeditionInfo {
    let currentExpedition: Int
    let maxExpedition: Int
    
    let expeditions: [Expedition]
    
    var currentOngoingTask: Int {
        expeditions.filter { expedition in
            expedition.isComplete == false
        }
        .count
    }
    
    
    
    var anyCompleted: Bool { currentOngoingTask < maxExpedition }
    var nextCompleteExpedition: Expedition? {
        expeditions.min {
            $0.recoveryTime.second < $1.recoveryTime.second
        }
    }
    var nextCompleteTime: RecoveryTime {
        RecoveryTime(second: nextCompleteExpedition?.recoveryTime.second ?? 0)
    }
    var nextCompletePercentage: Double {
        nextCompleteExpedition?.percentage ?? 0
    }
    
    var allCompleted: Bool { currentOngoingTask == 0 }
    var allCompleteTime: RecoveryTime {
        RecoveryTime(second: expeditions.max {
            $0.recoveryTime.second < $1.recoveryTime.second
        }?.recoveryTime.second ?? 0)
    }
    var maxTotalTime: Double {
        expeditions.map { $0.totalTime }
            .max {
                $0 < $1
            } ?? 72000.0
    }
    var allCompletedPercentage: Double { (maxTotalTime - Double(allCompleteTime.second)) / maxTotalTime }

    var nextCompleteExpeditionIgnoreFinished: Expedition? {
        expeditions.filter({ expedition in
            !expedition.isComplete
        }).min {
            $0.recoveryTime.second < $1.recoveryTime.second
        }
    }
    var nextCompleteTimeIgnoreFinished: RecoveryTime {
        RecoveryTime(second: nextCompleteExpedition?.recoveryTime.second ?? 0)
    }
    var nextCompletePercentageIgnoreFinished: Double {
        nextCompleteExpedition?.percentage ?? 0
    }

    var score: Float {
        if allCompleted { return 120.0/160.0 }
        else if anyCompleted { return 40.0/160.0 }
        else { return 0 }
    }
}

struct Expedition: Codable {
    let avatarSideIcon: String
    let remainedTimeStr: String
    let statusStr: String

    let totalTime: Double = Double(20 * 60 * 60)
    var percentage: Double {
        (totalTime - Double(recoveryTime.second)) / totalTime
    }

    var charactersEnglishName: String {
        let components = avatarSideIcon.components(separatedBy: "_")
        let fileName = components.last ?? ""
        return (fileName as NSString).deletingPathExtension
    }

    var avatarSideIconUrl: URL { URL(string: avatarSideIcon)! }
    var recoveryTime: RecoveryTime {
        RecoveryTime(second: Int(remainedTimeStr)!)
    }
    var isComplete: Bool {
        recoveryTime.isComplete
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarSideIcon = "avatarSideIcon"
        case remainedTimeStr = "remainedTime"
        case statusStr = "status"
    }

    var characterName: String {
        return self.characterCNName.localized
    }

    var characterCNName: String {
        switch charactersEnglishName {
        case "Aether":
            return "空"
        case "Lumine":
            return "荧"
        case "Gunnhildr", "Jean":
            return "琴"
        case "Amber", "Ambor":
            return "安柏"
        case "Kaeya", "Alberich":
            return "凯亚"
        case "Lisa", "Minci":
            return "丽莎"
        case "Venti":
            return "温迪"
        case "Razor":
            return "雷泽"
        case "Bennett":
            return "班尼特"
        case "Noelle":
            return "诺艾尔"
        case "Fischl":
            return "菲谢尔·冯·露弗施洛斯·那菲多特"
        case "Diluc":
            return "迪卢克"
        case "Klee":
            return "可莉"
        case "Diona":
            return "迪奥娜"
        case "Barbara":
            return "芭芭拉"
        case "Sucrose":
            return "砂糖"
        case "Albedo":
            return "阿贝多"
        case "Astrologist", "Mona", "Megistus":
            return "莫娜"
        case "Rosaria":
            return "罗莎莉亚"
        case "Eula":
            return "优菈"
        case "Xiangling":
            return "香菱"
        case "Keqing":
            return "刻晴"
        case "Ningguang":
            return "凝光"
        case "Qiqi":
            return "七七"
        case "Xingqiu":
            return "行秋"
        case "Chongyun":
            return "重云"
        case "Beidou":
            return "北斗"
        case "Xinyan":
            return "辛焱"
        case "Zhongli":
            return "钟离"
        case "Xiao":
            return "魈"
        case "Ganyu":
            return "甘雨"
        case "Hu", "Tao", "HuTao", "Hutao":
            return "胡桃"
        case "Yanfei":
            return "烟绯"
        case "Yun", "Jin", "Yunjin", "YunJin":
            return "云堇"
        case "Shenhe":
            return "申鹤"
        case "Yelan":
            return "夜兰"
        case "Kaedehara", "Kazuha":
            return "枫原万叶"
        case "Yoimiya":
            return "宵宫"
        case "Ayaka", "Kamisato", "KamisatoAyaka":
            return "神里绫华"
        case "Ayato", "KamisatoAyato":
            return "神里绫人"
        case "Thoma", "Tohma":
            return "托马"
        case "Sayu":
            return "早柚"
        case "Yae", "Miko":
            return "八重神子"
        case "Arataki", "Itto":
            return "荒泷一斗"
        case "Shinobu":
            return "久岐忍"
        case "Gorou":
            return "五郎"
        case "Sangonomiya", "Kokomi":
            return "珊瑚宫心海"
        case "Sara":
            return "九条裟罗"
        case "Shikanoin", "Heizou":
            return "鹿野院平藏"
        case "Raiden", "Shogun":
            return "雷电将军"
        case "Cyno":
            return "赛诺"
        case "Tighnari":
            return "提纳里"
        case "Collei":
            return "柯莱"
        case "Dori":
            return "多莉"
        case "Alhaitham":
            return "艾尔海森"
        case "Dehya":
            return "迪希雅"
        case "Nilou":
            return "妮露"
        case "Nahida":
            return "纳西妲"
        case "Lyney":
            return "林尼"
        case "Lynette":
            return "琳妮特"
        case "Iansan":
            return "伊安珊"
        case "Tartaglia", "Childe", "Ajax":
            return "达达利亚"

        default:
            return "（未知角色）"
        }
    }

}
