//
//  Servers.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  返回识别服务器信息的工具类

import Foundation

// 服务器类型
enum Server: String, CaseIterable, Identifiable {
    case china = "天空岛"
    case bilibili = "世界树"
    case us = "America"
    case eu = "Europe"
    case asia = "Asia"
    case cht = "TW/HK/MO"

    var id: String {
        switch self {
        case .china:
            return "cn_gf01"
        case .bilibili:
            return "cn_qd01"
        case .us:
            return "os_usa"
        case .eu:
            return "os_euro"
        case .asia:
            return "os_asia"
        case .cht:
            return "os_cht"
        }
    }

    var region: Region {
        switch self {
        case .china, .bilibili:
            return .cn
        case .us, .asia, .eu, .cht:
            return .global
        }
    }
    
    static func id(_ id: String) -> Self {
        switch id {
        case "cn_gf01":
            return .china
        case "cn_qd01":
            return .bilibili
        case "os_usa":
            return .us
        case "os_euro":
            return .eu
        case "os_asia":
            return .asia
        case "os_cht":
            return .cht
        default:
            return .china
        }
    }
    
}

// 地区类型，用于区分请求的Host URL
enum Region {
    // 国服，含官服和B服
    case cn
    // 国际服
    case global

    var value: String {
        switch self {
        case .cn:
            return "中国大陆"
        case .global:
            return "国际"
        }
    }
}

// extention for CoreData to save Server
extension AccountConfiguration {
    var server: Server {
        get {
            return Server(rawValue: self.serverRawValue!)!
        }
        set {
            self.serverRawValue = newValue.rawValue
        }
    }
}
