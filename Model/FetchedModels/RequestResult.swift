//
//  RequestResult.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  正常请求返回信息

import Foundation
import SwiftUI

struct RequestResult: Codable {
    let data: UserData?
    let message: String
    let retcode: Int
}

struct BasicInfoRequestResult: Codable {
    let data: BasicInfos?
    let message: String
    let retcode: Int
}

struct LedgerDataRequestResult: Codable {
    let data: LedgerData?
    let message: String
    let retcode: Int
}

struct AllAvatarDetailRequestDetail: Codable {
    let data: AllAvatarDetailModel?
    let message: String
    let retcode: Int
}

#if !os(watchOS)
struct SpiralAbyssDetailRequestResult: Codable {
    let data: SpiralAbyssDetail?
    let message: String
    let retcode: Int
}
#endif
