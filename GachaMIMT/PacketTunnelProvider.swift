//
//  PacketTunnelProvider.swift
//  GachaMIMT
//
//  Created by 戴藏龙 on 2023/4/1.
//

import GachaMIMTServer
import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    let server: MIMTServer = .shared

    override func startTunnel(
        options: [String: NSObject]?,
        completionHandler: @escaping (Error?) -> ()
    ) {
        server.start()
        let networkSettings =
            NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        networkSettings.mtu = 1500

        let proxySettings = NEProxySettings()
        proxySettings.httpServer = NEProxyServer(
            address: "127.0.0.1",
            port: 3000
        )
        proxySettings.httpEnabled = true
        proxySettings.httpsServer = NEProxyServer(
            address: "127.0.0.1",
            port: 3000
        )
        proxySettings.httpsEnabled = true
        proxySettings.matchDomains = [""]
//        proxySettings.matchDomains = ["www.baidu.com"]//["www.baidu.com","www.jianshu.com","127.0.0.1"]
        networkSettings.proxySettings = proxySettings

        let ipv4Settings = NEIPv4Settings(
            addresses: ["192.169.89.1"],
            subnetMasks: ["255.255.255.0"]
        )
        networkSettings.ipv4Settings = ipv4Settings
        setTunnelNetworkSettings(networkSettings) { error in
            completionHandler(error)
        }
    }

    override func stopTunnel(
        with reason: NEProviderStopReason,
        completionHandler: @escaping () -> ()
    ) {
        server.stop()
        completionHandler()
    }

    override func handleAppMessage(
        _ messageData: Data,
        completionHandler: ((Data?) -> ())?
    ) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }

    override func sleep(completionHandler: @escaping () -> ()) {
        // Add code here to get ready to sleep.
        completionHandler()
    }

    override func wake() {
        // Add code here to wake up.
    }
}
