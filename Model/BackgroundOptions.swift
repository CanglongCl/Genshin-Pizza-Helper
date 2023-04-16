//
//  ColorHandler.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/8/12.
//  Widget和App内的背景支持

import Foundation
import SwiftUI

// MARK: - BackgroundOptions

struct BackgroundOptions {
    static let colors: [String] = [
        "★灰",
        "★★绿",
        "★★★蓝",
        "★★★★紫",
        "★★★★★金",
        "★★★★★红",
        "风元素",
        "水元素",
        "冰元素",
        "火元素",
        "岩元素",
        "雷元素",
        "草元素",
        "纠缠之缘",
    ]
    static let elements: [String] = [
        "风元素",
        "水元素",
        "冰元素",
        "火元素",
        "岩元素",
        "雷元素",
        "草元素",
    ]
    static let namecards: [String] = [
        "丽莎・沙漏",
        "菲谢尔・夜鸦",
        "纪行・绕尘",
        "莫娜・天星",
        "纪行・海蓝",
        "优菈・冰印",
        "成就・雪峰",
        "庆典・一揆",
        "鹿野院平藏・鞠毬",
        "阿贝多・阳花",
        "纪行・容彩",
        "稻妻・珊瑚宫之纹",
        "成就・深秘",
        "庆典・慧果",
        "珊瑚宫心海・渊",
        "公子・魔装",
        "庆典・斗剧",
        "重云・灵刃",
        "可莉・爆弹",
        "雷泽・奔狼",
        "宵宫・琉金火花",
        "蒙德・风吟",
        "成就・强弓",
        "埃洛伊・曙光记",
        "庆典・觥筹",
        "纪行・风花",
        "成就・旅居",
        "忍冬・古树",
        "成就・层岩",
        "胡桃·安神",
        "七七・冷藏",
        "璃月・云间",
        "庆典・光鳞",
        "流明・辉石",
        "枫原万叶・秋山椛狩",
        "庆典・无相",
        "罗莎莉亚・苦役",
        "成就・雪乡",
        "云堇・对韵",
        "稻妻・神里之纹",
        "温迪・天青",
        "甘雨・麟迹",
        "稻妻・雷电之纹",
        "庆典・浩瀚",
        "纪行・盛夏",
        "纪行・白英",
        "纪行・天命",
        "九条裟罗・天狗",
        "成就・敲针",
        "纪行・熄星",
        "成就・游遍",
        "稻妻・常世",
        "魈・傩面",
        "纪行・流彩",
        "刻晴・雷楔",
        "蒙德・祝愿",
        "纪行・鸣神大社",
        "北斗・拔锚",
        "申鹤・栉掠",
        "香菱・出锅",
        "凝光・凤仪",
        "夜兰・一掷",
        "成就・石龙",
        "成就・遍历",
        "纪行・捕风",
        "稻妻・九条之纹",
        "行秋・雨虹",
        "神里绫人・涟漪",
        "雷电将军・开眼",
        "庆典・棋谭",
        "八重神子・梦狐",
        "琴・风向",
        "庆典・魔球",
        "芭芭拉・流淌",
        "成就・相逢",
        "成就・雷音",
        "托马・炎袖",
        "璃月・岩寂",
        "成就・挑战・其二",
        "迪奥娜・呜喵",
        "成就・合扇",
        "纪行・蛰醒",
        "成就・挑战・其三",
        "纪行・白垩",
        "神里绫华・扇子",
        "成就・山民",
        "庆典・躲猫",
        "成就・挑战",
        "班尼特・认可",
        "成就・侠行",
        "迪卢克・燃烧",
        "稻妻・鹫羽",
        "成就・门扉",
        "纪行・神将",
        "安柏・兔兔",
        "辛焱・唱罢",
        "纪行・逐月",
        "五郎・悠犬",
        "成就・繁花",
        "纪行・明霄",
        "早柚・不倒貉貉",
        "烟绯・公正",
        "砂糖・创生",
        "诺艾尔・守护",
        "凯亚・孔雀",
        "成就・壶歌",
        "璃月・千帆",
        "庆典・妙算",
        "庆典・灯昼",
        "成就・殊技",
        "一斗・鬼颜",
        "庆典・盛宴",
        "久岐忍・络",
        "蒙德・英名",
        "稻妻・神樱",
        "钟离・天星",
        "提纳里・沐露",
        "柯莱・豹蔚",
        "多莉・魔灯",
        "纪行・深林",
        "成就・漫行",
        "成就・逢缘",
        "须弥・瑶林",
        "须弥・照览",
        "须弥・正明", /* 3.1 */
        "赛诺・幽缄",
        "妮露・莲舞",
        "坎蒂丝・苍鹭",
        "纪行・归风",
        "成就・七芒",
        "须弥・踏沙",
        "成就・镜梦", /* 3.2-3.4 */
        "纪行・蕈原",
        "纳西妲・仰月",
        "流浪者・浮歌",
        "莱依拉・昼梦",
        "纪行・灵津",
        "纪行・合韵",
        "珐露珊・封秘",
        "成就・七圣",
        "艾尔海森・诲明",
        "须弥·砂岚",
        "瑶瑶・月桂",
        "迪希雅・净焰",
        "米卡・索引",
        "纪行・意巧",
    ]
    static let allOptions: [String] = BackgroundOptions
        .colors + BackgroundOptions.namecards
}

extension WidgetBackground {
    static let defaultBackground: WidgetBackground = .init(
        identifier: "纪行・熄星",
        display: "纪行・熄星"
    )
    static var randomBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.allOptions.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomColorBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.colors.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomNamecardBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.namecards.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomElementBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.elements.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomElementOrNamecardBackground: WidgetBackground {
        let pickedBackgroundId = (
            BackgroundOptions.elements + BackgroundOptions
                .namecards
        ).randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }
}
