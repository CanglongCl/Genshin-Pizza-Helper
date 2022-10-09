//
//  AppConfig.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/26.
//

import Foundation

enum AppConfiguration {
  case Debug
  case TestFlight
  case AppStore
}

struct AppConfig {
  // This is private because the use of 'appConfiguration' is preferred.
  private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

  // This can be used to add debug statements.
  static var isDebug: Bool {
    #if DEBUG
      return true
    #else
      return false
    #endif
  }

  static var appConfiguration: AppConfiguration {
    if isDebug {
      return .Debug
    } else if isTestFlight {
      return .TestFlight
    } else {
      return .AppStore
    }
  }
}
