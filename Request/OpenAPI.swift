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
        private static func fetchPlayerDatas (
            _ uid: String,
            completion: @escaping (
                PlayerDetailsFetchResult
            ) -> ()
        ) {
            // 请求类别
            #if DEBUG
//            let urlStr = "https://enka.network/u/153201631/__data.json"
            let urlStr = "http://ophelper.top/static/player_detail_data_example.json"
            #else
            let urlStr = "https://enka.network/u/\(uid)/__data.json"
            #endif
            let url = URL(string: urlStr)!

            // 请求
            HttpMethod<PlayerDetailFetchModel>
                .openRequest(
                    .get,
                    url
                ) { result in
                    switch result {

                    case .success(let requestResult):
                        print("request succeed")
                        completion(.success(requestResult))
                    case .failure(let requestError):
                        completion(.failure(requestError))
                    }
                }
        }


        /// 获取游戏内玩家详细信息
        /// - Parameters:
        ///     - uid: 用户UID
        ///     - completion: 数据
        static func fetchPlayerDetail (
            _ uid: String,
            dateWhenNextRefreshable: Date?,
            completion: @escaping (
                Result<PlayerDetailFetchModel, PlayerDetail.PlayerDetailError>
            ) -> ()
        ) {
            if let date = dateWhenNextRefreshable, date > Date() {
                completion(.failure(.refreshTooFast(dateWhenRefreshable: date)))
                print("PLAYER DETAIL FETCH 刷新太快了，请在\(date.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate)秒后刷新")
            } else {
                fetchPlayerDatas(uid) { result in
                    switch result {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        switch error {
                        case .dataTaskError(let message):
                            completion(.failure(.failToGetCharacterData(message: message)))
                        case .decodeError(let message):
                            completion(.failure(.failToGetCharacterData(message: message)))
                        case .errorWithCode(let code):
                            completion(.failure(.failToGetCharacterData(message: "ERROR CODE \(code)")))
                        case .noResponseData:
                            completion(.failure(.failToGetCharacterData(message: "未找到数据")))
                        case .responseError:
                            completion(.failure(.failToGetCharacterData(message: "请求无响应")))
                        }
                    }
                }
            }
        }

        /// 获取原神辞典数据
        /// - Parameters:
        ///     - completion: 数据
        static func fetchGenshinDictionaryData (
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

                    case .success(let requestResult):
                        print("request succeed")
                        completion(requestResult)

                    case .failure(_):
                        print("request Genshin Dictionary Data Fail")
                        break
                    }
                }
        }
    }
}
