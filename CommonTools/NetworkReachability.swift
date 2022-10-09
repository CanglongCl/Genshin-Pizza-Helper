//
//  NetworkReachability.swift
//  原神披萨小助手
//
//  Created by Bill Haku on 2022/8/6.
//  检查网络可用性

import Foundation
#if !os(watchOS)
import SystemConfiguration

// 检查网络可用性
class NetworkReachability: ObservableObject {
    @Published private(set) var reachable: Bool = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://api-takumi-record.mihoyo.com")

    init() {
        self.reachable = checkConnection()
    }

    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!connectionRequired || canConnectWithoutIntervention)
    }

    func checkConnection() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)

        return isNetworkReachable(with: flags)
    }
}
#else
class NetworkReachability: ObservableObject {
    @Published private(set) var reachable: Bool = true
}
#endif

enum ConnectStatus {
    case unknown
    case success
    case fail
    case testing
}
