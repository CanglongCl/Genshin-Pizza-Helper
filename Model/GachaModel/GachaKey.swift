//
//  GachaKe.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/28.
//

import CommonCrypto
import Foundation
import HBMihoyoAPI

@available(iOS 13, *)
extension MihoyoAPI {
    public static func genAuthKey(
        account: AccountConfiguration,
        completion: @escaping (
            (Result<GenAuthKeyResult, GetGachaError>) -> ()
        )
    ) {
        let gameBiz: String
        switch account.server.region {
        case .cn: gameBiz = "hk4e_cn"
        case .global: gameBiz = "hk4e_global"
        }
        let genAuthKeyParam = GenAuthKeyParam(
            gameUid: account.uid!,
            region: account.server.id,
            gameBiz: gameBiz
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let requestBody = try! encoder.encode(genAuthKeyParam)

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-takumi.mihoyo.com"
//        switch account.server.region {
//        case .cn: urlComponents.host = "api-takumi.mihoyo.com"
//        case .global: urlComponents.host = "???"
//        }
        urlComponents.path = "/binding/api/genAuthKey"

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody

        print(request)

        request.allHTTPHeaderFields = [
            "Content-Type": "application/json; charset=utf-8",
            "Host": "api-takumi.mihoyo.com",
            "Accept": "application/json, text/plain, */*",
            "Referer": "https://webstatic.mihoyo.com",
            "x-rpc-app_version": "2.38.1",
            "x-rpc-client_type": "5",
            "x-rpc-device_id": "CBEC8312-AA77-489E-AE8A-8D498DE24E90",
            "x-requested-with": "com.mihoyo.hyperion",
            "Cookie": account.cookie!,
            "DS": get_ds_token(),
        ]

        print(request.allHTTPHeaderFields!)
        print(String(data: requestBody, encoding: .utf8)!)
        URLSession.shared.dataTask(with: request) { data, _, error in
            print(error ?? "ErrorInfo nil")
            guard error == nil
            else {
                completion(.failure(.genAuthKeyError(
                    message: error!
                        .localizedDescription
                ))); return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(
                    GenAuthKeyResult.self,
                    from: data!
                )
                completion(.success(result))
            } catch {
                completion(.failure(.genAuthKeyError(
                    message: error
                        .localizedDescription
                )))
            }
        }.resume()
        func get_ds_token() -> String {
            let s: String
            switch account.server.region {
            case .cn:
                s = "yUZ3s0Sna1IrSNfk29Vo6vRapdOyqyhB"
            case .global:
                s = "okr4obncj8bw5a65hbnn5oo6ixjc3l9w"
                // TODO: Manually wanted crash.
                assert(false, "CanglongCI wants a crash here.")
            }
            let t = String(Int(Date().timeIntervalSince1970))
            let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyz1234567890"
            let r = String((0 ..< 6).map { _ in
                lettersAndNumbers.randomElement()!
            })
            let c = "salt=\(s)&t=\(t)&r=\(r)".md5
            print(t + "," + r + "," + c)
            print("salt=\(s)&t=\(t)&r=\(r)")
            return t + "," + r + "," + c
        }
    }

    public static func getCookieToken(
        cookieContainStoken: String,
        completion: @escaping (
            (Result<(cookieToken: String, uid: String), GetGachaError>) -> ()
        )
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "passport-api.mihoyo.com"
//        switch account.server.region {
//        case .cn: urlComponents.host = "api-takumi.mihoyo.com"
//        case .global: urlComponents.host = "???"
//        }
        urlComponents.path = "/account/auth/api/getCookieAccountInfoBySToken"

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Cookie": cookieContainStoken,
        ]

        print(request)

        URLSession.shared.dataTask(with: request) { data, _, error in
//            print(error ?? "ErrorInfo nil")
            guard error == nil
            else {
                completion(.failure(.genAuthKeyError(
                    message: error!
                        .localizedDescription
                ))); return
            }
//            print(respond)
//            print(String(data: data!, encoding: .utf8))
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(
                    GetCookieTokenResult.self,
                    from: data!
                )
                if let data = result.data {
                    completion(.success((data.cookieToken, data.uid)))
                } else {
                    completion(.failure(.genAuthKeyError(
                        message: result
                            .message
                    )))
                }
            } catch {
                completion(.failure(.genAuthKeyError(
                    message: error
                        .localizedDescription
                )))
            }
        }.resume()
    }
}

// MARK: - GetCookieTokenResult

private struct GetCookieTokenResult: Codable {
    struct GetCookieTokenData: Codable {
        let uid: String
        let cookieToken: String
    }

    let retcode: Int
    let message: String
    let data: GetCookieTokenData?
}

// MARK: - GenAuthKeyParam

private struct GenAuthKeyParam: Encodable {
    let authAppid: String = "webview_gacha"
    let gameUid: String
    let region: String
    let gameBiz: String
}

// MARK: - GenAuthKeyResult

public struct GenAuthKeyResult: Codable {
    // MARK: Public

    public struct GenAuthKeyData: Codable {
        let authkeyVer: Int
        let signType: Int
        let authkey: String
    }

    // MARK: Internal

    let retcode: Int
    let message: String
    let data: GenAuthKeyData?
}

extension UUID {
    enum UUIDVersion: Int {
        case v3 = 3
        case v5 = 5
    }

    enum UUIDv5NameSpace: String {
        case dns = "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
        case url = "6ba7b811-9dad-11d1-80b4-00c04fd430c8"
        case oid = "6ba7b812-9dad-11d1-80b4-00c04fd430c8"
        case x500 = "6ba7b814-9dad-11d1-80b4-00c04fd430c8"
    }

    init(version: UUIDVersion, name: String, nameSpace: UUIDv5NameSpace) {
        // Get UUID bytes from name space:
        var spaceUID = UUID(uuidString: nameSpace.rawValue)!.uuid
        var data =
            withUnsafePointer(to: &spaceUID) { [count = MemoryLayout.size(ofValue: spaceUID)] in
                Data(bytes: $0, count: count)
            }

        // Append name string in UTF-8 encoding:
        data.append(contentsOf: name.utf8)

        // Compute digest (MD5 or SHA1, depending on the version):
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            switch version {
            case .v3:
                _ = CC_MD5(ptr.baseAddress, CC_LONG(data.count), &digest)
            case .v5:
                _ = CC_SHA1(ptr.baseAddress, CC_LONG(data.count), &digest)
            }
        }

        // Set version bits:
        digest[6] &= 0x0F
        digest[6] |= UInt8(version.rawValue) << 4
        // Set variant bits:
        digest[8] &= 0x3F
        digest[8] |= 0x80

        // Create UUID from digest:
        self = NSUUID(uuidBytes: digest) as UUID
    }
}

let NAMESPACE_URL = UUID(uuidString: "6ba7b812-9dad-11d1-80b4-00c04fd430c8")!
