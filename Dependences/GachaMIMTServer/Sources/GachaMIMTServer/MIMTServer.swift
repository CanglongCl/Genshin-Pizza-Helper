//
//  File.swift
//  
//
//  Created by 戴藏龙 on 2023/3/28.
//

import RustXcframework
import Foundation

@available(iOS 13.0, *)
public class MIMTServer {
    private let server: ProxyServer = .init()

    private init() {}

    public static let shared: MIMTServer = .init()

    public var isRunning: Bool {
        server.is_running()
    }

    public func start() {
        Task {
            await server.start()
        }
    }

    public func stop() {
        Task {
            await server.stop()
        }
    }

    public func popStashedURL() -> [String] {
        server.get_uris().map({ item in
            item.as_str().toString()
        })
    }
}
