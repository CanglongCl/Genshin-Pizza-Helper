//
//  GachaFetch.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/27.
//

import CoreData
import Foundation
import HBMihoyoAPI

@available(iOS 13, *)
extension MihoyoAPI {
    static let GET_GACHA_DELAY_RANDOM_RANGE: Range<Double> = 0.8 ..< 1.5

    public static func getGachaLogAndSave(
        server: Server,
        authKey: GenAuthKeyResult.GenAuthKeyData,
        manager: GachaModelManager,
        observer: GachaFetchProgressObserver,
        completion: @escaping (
            (Result<(), GetGachaError>) -> ()
        )
    ) {
        innerGetGachaLogAndSave(
            server: server,
            authkey: authKey,
            manager: manager,
            observer: observer
        ) { result in
            completion(result)
        }
    }

    public static func getGachaLogAndSave(
        account: AccountConfiguration,
        manager: GachaModelManager,
        observer: GachaFetchProgressObserver,
        completion: @escaping (
            (Result<(), GetGachaError>) -> ()
        )
    ) {
        genAuthKey(account: account) { result in
            switch result {
            case let .success(data):
                if let authKey = data.data {
                    innerGetGachaLogAndSave(
                        server: account.server,
                        authkey: authKey,
                        manager: manager,
                        observer: observer
                    ) { result in
                        completion(result)
                    }
                } else {
                    completion(.failure(.genAuthKeyError(
                        message: data
                            .message
                    )))
                }
            case let .failure(err):
                completion(.failure(.genAuthKeyError(
                    message: err
                        .localizedDescription
                )))
            }
        }
    }

    private static func innerGetGachaLogAndSave(
        server: Server,
        authkey: GenAuthKeyResult.GenAuthKeyData,
        gachaType: _GachaType = .standard,
        page: Int = 1,
        endId: String = "0",
        manager: GachaModelManager,
        observer: GachaFetchProgressObserver,
        completion: @escaping (
            (Result<(), GetGachaError>) -> ()
        )
    ) {
        observer.fetching(page: page, gachaType: gachaType)
        let url = genGachaURL(
            server: server,
            authkey: authkey,
            gachaType: gachaType,
            page: page,
            endId: endId
        )

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            print(error ?? "ErrorInfo nil")
            guard error == nil
            else {
                completion(.failure(.networkError(
                    message: error?
                        .localizedDescription ?? "Unknow Network Error"
                ))); return
            }
//            print(respond!)
            print(String(data: data!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            do {
                let result = try decoder.decode(
                    GachaResult_FM.self,
                    from: data!
                )
                let items = try result.toGachaItemArray()
                DispatchQueue.main.async {
                    observer.got(items)
                }
                manager.addRecordItems(items) { itemIsNewAndSavedSucceed in
                    if itemIsNewAndSavedSucceed {
                        DispatchQueue.main.async {
                            observer.saveNewItemSucceed()
                        }
                    }
                }
                if observer.shouldCancel {
                    completion(.success(()))
                } else if !items.isEmpty {
                    DispatchQueue.global(qos: .userInteractive)
                        .asyncAfter(
                            deadline: .now() + TimeInterval
                                .random(in: GET_GACHA_DELAY_RANDOM_RANGE)
                        ) {
                            innerGetGachaLogAndSave(
                                server: server,
                                authkey: authkey,
                                gachaType: gachaType,
                                page: page + 1,
                                endId: items.last!.id,
                                manager: manager,
                                observer: observer
                            ) { result in
                                completion(result)
                            }
                        }
                } else if let gachaType = gachaType.next() {
                    DispatchQueue.global(qos: .userInteractive)
                        .asyncAfter(
                            deadline: .now() + TimeInterval
                                .random(in: GET_GACHA_DELAY_RANDOM_RANGE)
                        ) {
                            innerGetGachaLogAndSave(
                                server: server,
                                authkey: authkey,
                                gachaType: gachaType,
                                manager: manager,
                                observer: observer
                            ) { result in
                                completion(result)
                            }
                        }
                } else {
                    completion(.success(()))
                }
            } catch let error as GetGachaError {
                completion(.failure(error))
            } catch {
                print(error.localizedDescription)
                completion(
                    .failure(
                        .decodeError(
                            message: "DECODE ITEM: \(String(data: data!, encoding: .utf8)!)"
                        )
                    )
                )
            }
        }.resume()
    }
}
