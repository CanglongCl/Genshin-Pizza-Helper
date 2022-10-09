//
//  OpenAPI.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/17.
//

import Foundation

extension API {
    struct OpenAPIs {
        /// 获取当前活动信息
        /// - Parameters:
        ///     - completion: 数据
        static func fetchCurrentEvents (
            completion: @escaping (
                CurrentEventsFetchResult
            ) -> ()
        ) {
            // 请求类别
            let urlStr = "https://api.ambr.top/assets/data/event.json"
            let url = URL(string: urlStr)!

            // 请求
            HttpMethod<CurrentEvent>
                .openRequest(
                    .get,
                    url
                ) { result in
                    switch result {

                    case .success(let requestResult):
                        print("request succeed")
                        completion(.success(requestResult))

                    case .failure(let requestError):
                        switch requestError {
                        case .decodeError(let message):
                            completion(.failure(.decodeError(message)))
                        default:
                            completion(.failure(.requestError(requestError)))
                        }
                    }
                }
        }

        /// 获取游戏内玩家详细信息
        /// - Parameters:
        ///     - uid: 用户UID
        ///     - completion: 数据
        static func fetchPlayerDatas (
            _ uid: String,
            completion: @escaping (
                PlayerDetailsFetchResult
            ) -> ()
        ) {
            // 请求类别
            let urlStr = "https://enka.network/u/\(uid)/__data.json"
            let url = URL(string: urlStr)!

            // 请求
            HttpMethod<PlayerDetails>
                .openRequest(
                    .get,
                    url
                ) { result in
                    switch result {

                    case .success(let requestResult):
                        print("request succeed")
                        completion(.success(requestResult))

                    case .failure(let requestError):
                        switch requestError {
                        case .decodeError(let message):
                            completion(.failure(.decodeError(message)))
                        default:
                            completion(.failure(.requestError(requestError)))
                        }
                    }
                }
        }
    }
}
