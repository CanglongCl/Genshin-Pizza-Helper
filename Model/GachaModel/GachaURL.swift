//
//  GachaURL.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/28.
//

import Foundation
import HBMihoyoAPI

func genGachaURL(
    server: Server,
    authkey: GenAuthKeyResult.GenAuthKeyData,
    gachaType: _GachaType,
    page: Int,
    endId: String
)
    -> URL {
    let gameBiz: String
    switch server.region {
    case .cn: gameBiz = "hk4e_cn"
    case .global: gameBiz = "hk4e_global"
    }

    let LANG = "zh-cn"

    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    switch server.region {
    case .cn: urlComponents.host = "hk4e-api.mihoyo.com"
    case .global: urlComponents.host = "hk4e-api-os.hoyoverse.com"
    }
    urlComponents.path = "/event/gacha_info/api/getGachaLog"

    let gameVersion: String
    switch server.region {
    case .cn: gameVersion = "CNRELiOS3.5.0_R13695448_S13586568_D13718257"
    case .global: gameVersion = "OSRELWin3.5.0_R13695448_S13586568_D13948595"
    }

    urlComponents.queryItems = [
        .init(name: "win_mode", value: "fullscreen"),
        .init(name: "authkey_ver", value: String(authkey.authkeyVer)),
        .init(name: "sign_type", value: String(authkey.signType)),
        .init(name: "auth_appid", value: "webview_gacha"),
        .init(name: "init_type", value: "301"),
        .init(
            name: "gacha_id",
            value: "9e72b521e716d347e3027a4f71efc08f1455d4b2"
        ),
        .init(
            name: "timestamp",
            value: String(Int(Date().timeIntervalSince1970))
        ),
        .init(name: "lang", value: LANG),
        .init(name: "device_type", value: "mobile"),
        .init(
            name: "game_version",
            value: gameVersion
        ),
        .init(name: "plat_type", value: "ios"),
        .init(name: "region", value: server.id),
        .init(name: "game_biz", value: gameBiz),
        .init(name: "gacha_type", value: String(gachaType.rawValue)),
        .init(name: "page", value: String(page)),
        .init(name: "size", value: "20"),
        .init(name: "end_id", value: endId),
    ]

    urlComponents.percentEncodedQueryItems!.append(.init(
        name: "authkey",
        value: authkey.authkey
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    ))

    return urlComponents.url!
}
