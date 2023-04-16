//
//  OpenAPI.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/17.
//

import Foundation
import HBMihoyoAPI

extension API {
    enum OpenAPIs {
        // MARK: Internal

        /// 获取当前活动信息
        /// - Parameters:
        ///     - completion: 数据
        static func fetchCurrentEvents(
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
                    url,
                    cachedPolicy: .reloadIgnoringLocalCacheData
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(.success(requestResult))

                    case let .failure(requestError):
                        switch requestError {
                        case let .decodeError(message):
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
        static func fetchPlayerDetail(
            _ uid: String,
            dateWhenNextRefreshable: Date?,
            completion: @escaping (
                Result<PlayerDetailFetchModel, PlayerDetail.PlayerDetailError>
            ) -> ()
        ) {
            if let date = dateWhenNextRefreshable, date > Date() {
                completion(.failure(.refreshTooFast(dateWhenRefreshable: date)))
                print(
                    "PLAYER DETAIL FETCH 刷新太快了，请在\(date.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate)秒后刷新"
                )
            } else {
                fetchPlayerDatas(uid) { result in
                    switch result {
                    case let .success(model):
                        completion(.success(model))
                    case let .failure(error):
                        switch error {
                        case let .dataTaskError(message):
                            completion(
                                .failure(
                                    .failToGetCharacterData(message: message)
                                )
                            )
                        case let .decodeError(message):
                            completion(
                                .failure(
                                    .failToGetCharacterData(message: message)
                                )
                            )
                        case let .errorWithCode(code):
                            completion(
                                .failure(
                                    .failToGetCharacterData(
                                        message: "ERROR CODE \(code)"
                                    )
                                )
                            )
                        case .noResponseData:
                            completion(
                                .failure(
                                    .failToGetCharacterData(message: "未找到数据")
                                )
                            )
                        case .responseError:
                            completion(
                                .failure(
                                    .failToGetCharacterData(message: "请求无响应")
                                )
                            )
                        }
                    }
                }
            }
        }

        /// 获取原神辞典数据
        /// - Parameters:
        ///     - completion: 数据
        static func fetchGenshinDictionaryData(
            completion: @escaping (
                [GDDictionary]
            ) -> ()
        ) {
            // 请求类别
            let urlStr = "https://dataset.genshin-dictionary.com/words.json"
            let url = URL(string: urlStr)!

            // 请求
            HttpMethod<[GDDictionary]>
                .openRequest(
                    .get,
                    url
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(requestResult)

                    case .failure:
                        print("request Genshin Dictionary Data Fail")
                    }
                }
        }

        // MARK: Private

        /// 获取游戏内玩家详细信息
        /// - Parameters:
        ///     - uid: 用户UID
        ///     - completion: 数据
        private static func fetchPlayerDatas(
            _ uid: String,
            completion: @escaping (
                PlayerDetailsFetchResult
            ) -> ()
        ) {
            // 请求类别
            #if DEBUG
//            let urlStr = "https://enka.network/api/uid/\(uid)/"
            let urlStr =
                "https://ophelper.top/static/player_detail_data_example_2.json"
            #else
            let urlStr = "https://enka.network/api/uid/\(uid)/"
            #endif
            let url = URL(string: urlStr)!

            // 请求
            HttpMethod<PlayerDetailFetchModel>
                .openRequest(
                    .get,
                    url
                ) { result in
                    switch result {
                    case let .success(requestResult):
                        print("request succeed")
                        completion(.success(requestResult))
                    case let .failure(requestError):
                        completion(.failure(requestError))
                    }
                }
        }
    }
}
