//
//  Error.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  错误信息

import Foundation

enum RequestError: Error {
    case dataTaskError(String)
    case noResponseData
    case responseError
    case decodeError(String)
    case errorWithCode(Int)
}

struct ErrorCode: Codable {
    var code: Int
    var message: String?
}

enum FetchError: Error, Equatable {
    static func == (lhs: FetchError, rhs: FetchError) -> Bool {
        return lhs.description == rhs.description && lhs.message == rhs.message
    }

    case noFetchInfo
    
    case cookieInvalid(Int, String) // 10001
    case unmachedAccountCookie(Int, String) // 10103, 10104
    case accountInvalid(Int, String) // 1008
    case dataNotFound(Int, String) // -1, 10102
    
    case notLoginError(Int, String) // -100
    
    case decodeError(String)
    
    case requestError(RequestError)
    
    case unknownError(Int, String)
    
    case defaultStatus
    
    case accountUnbound

    case errorWithCode(Int)
}

extension FetchError {
    var description: String {
        switch self {
        case .defaultStatus:
            return "请先刷新以获取树脂状态".localized
            
        case .noFetchInfo:
            return "请长按小组件选择帐号".localized
            
        case .cookieInvalid(let retcode, _):
            return String(format: NSLocalizedString("错误码%lld：Cookie失效，请重新登录", comment: "错误码%@：Cookie失效，请重新登录"), retcode)
        case .unmachedAccountCookie(let retcode, _):
            return String(format: NSLocalizedString("错误码%lld：米游社帐号与UID不匹配", comment: "错误码%@：米游社帐号与UID不匹配"), retcode)
        case .accountInvalid(let retcode, _):
            return String(format: NSLocalizedString("错误码%lld：UID有误", comment: "错误码%@：UID有误"), retcode)
        case .dataNotFound( _, _):
            return "请前往米游社（或Hoyolab）打开旅行便笺功能".localized
        case .decodeError( _):
            return "解码错误：请检查网络环境".localized
        case .requestError( _):
            return "网络错误".localized
        case .notLoginError( _, _):
            return "未获取到登录信息，请重试".localized
        case .unknownError(let retcode, _):
            return String(format: NSLocalizedString("未知错误码：%lld", comment: "未知错误码：%lld"), retcode)
        default:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .defaultStatus:
            return ""
            
        case .noFetchInfo:
            return ""
        case .notLoginError(let retcode, let message):
            return "(\(retcode))" + message
        case .cookieInvalid(_, _):
            return ""
        case .unmachedAccountCookie(_, let message):
            return message
        case .accountInvalid(_, let message):
            return message
        case .dataNotFound(let retcode, let message):
            return "(\(retcode))" + message
        case .decodeError(let message):
            return message
        case .requestError(let requestError):
            switch requestError {
            case .dataTaskError(let message):
                return "\(message)"
            case .noResponseData:
                return "无返回数据".localized
            case .responseError:
                return "无响应".localized
            default:
                return "未知错误".localized
            }
        case .unknownError(_, let message):
            return message
        default:
            return ""
        }
    
    }
}


