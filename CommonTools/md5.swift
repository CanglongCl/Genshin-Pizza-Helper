//
//  md5.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  计算md5的扩展

import CommonCrypto
import Foundation

extension String {
    /**
     - returns: the String, as an MD5 hash.
     */
    public var md5: String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>
            .allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }

    public var sha256: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format: "%02x", $1) }
    }
}

extension Data {
    public var sha256: String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return String(data: Data(hash), encoding: .utf8)!
    }
}

extension Double {
    public func selfTimes(p: Int) -> Double {
        var res = self
        var x = p - 1
        while x > 0 {
            res *= res
            x -= 1
        }
        return res
    }
}

extension String {
    @available(iOS 15, *)
    public func toAttributedString() -> AttributedString {
        let attributedString = try? AttributedString(markdown: self)
        return attributedString ?? ""
    }
}
