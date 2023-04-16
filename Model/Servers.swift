//
//  Servers.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  返回识别服务器信息的工具类

import Foundation
import HBMihoyoAPI

// extention for CoreData to save Server
extension AccountConfiguration {
    var server: Server {
        get {
            Server(rawValue: serverRawValue!)!
        }
        set {
            serverRawValue = newValue.rawValue
        }
    }
}
