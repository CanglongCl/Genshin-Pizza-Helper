//
//  HomeAPI.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/26.
//

import Foundation
import HBPizzaHelperAPI

extension API {
    enum HomeAPIs {
        /// 获取最新系统版本
        /// - Parameters:
        ///     - isBeta: 是否是Beta
        ///     - completion: 数据
        static func fetchNewestVersion(
            isBeta: Bool,
            completion: @escaping (
                NewestVersion
            ) -> ()
        ) {
            // 请求类别
            var urlStr: String
            if isBeta {
                urlStr = "api/app/newest_version_beta.json"
            } else {
                urlStr = "api/app/newest_version.json"
            }

            // 请求
            HttpMethod<NewestVersion>
                .homeRequest(
                    .get,
                    urlStr,
                    cachedPolicy: .reloadIgnoringLocalCacheData
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(requestResult)

                    case .failure:
                        print("request newest version fail")
                    }
                }
        }

        /// 从EnkaNetwork获取角色ID对应详细信息
        /// - Parameters:
        ///     - completion: 数据
        static func fetchENCharacterDetailDatas(
            completion: @escaping (
                ENCharacterMap
            ) -> ()
        ) {
            // 请求类别
            let urlStr = "api/players/characters.json"

            // 请求
            HttpMethod<ENCharacterMap>
                .homeRequest(
                    .get,
                    urlStr,
                    cachedPolicy: .reloadIgnoringLocalCacheData
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(requestResult)

                    case .failure:
                        print("fetch ENCharacterDetailDatas fail")
                    }
                }
        }

        /// 从EnkaNetwork获取角色ID对应本地化信息
        /// - Parameters:
        ///     - completion: 数据
        static func fetchENCharacterLocDatas(
            completion: @escaping (
                ENCharacterLoc
            ) -> ()
        ) {
            // 请求类别
            let urlStr = "api/players/loc.json"

            // 请求
            HttpMethod<ENCharacterLoc>
                .homeRequest(
                    .get,
                    urlStr,
                    cachedPolicy: .reloadIgnoringLocalCacheData
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(requestResult)

                    case .failure:
                        print("fetch ENCharacterLocDatas fail")
                    }
                }
        }
    }
}
