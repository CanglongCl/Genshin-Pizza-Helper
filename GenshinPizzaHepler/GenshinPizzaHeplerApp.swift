//
//  GenshinPizzaHeplerApp.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/7/19.
//

import StoreKit
import SwiftUI

// MARK: - GenshinPizzaHeplerApp

@main
struct GenshinPizzaHeplerApp: App {
    // MARK: Lifecycle

    init() {
//        let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! Int
        let defaultStandard = UserDefaults.standard
        let isPolicySaved = defaultStandard.bool(forKey: "isPolicyShown")
        if !isPolicySaved {
            defaultStandard.setValue(false, forKey: "isPolicyShown")
        }
//        let checkedNewestVersion = defaultStandard.integer(forKey: "checkedNewestVersion")
//        if checkedNewestVersion != buildVersion {
//            defaultStandard.setValue(buildVersion, forKey: "checkedNewestVersion")
//        }
        defaultStandard.synchronize()
        #if !os(watchOS)
        UserNotificationCenter.shared.askPermission()
        #endif
    }

    // MARK: Internal

    let viewModel: ViewModel = .shared
    #if !os(watchOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    #endif
    @StateObject
    var storeManager = StoreManager()

    let productIDs = [
        "Canglong.GenshinPizzaHepler.IAP.6",
        "Canglong.GenshinPizzaHepler.IAP.30",
        "Canglong.GenshinPizzaHepler.IAP.98",
        "Canglong.GenshinPizzaHepler.IAP.198",
        "Canglong.GenshinPizzaHepler.IAP.328",
        "Canglong.GenshinPizzaHepler.IAP.648",
    ]

    var body: some Scene {
        WindowGroup {
            #if os(watchOS)
            ContentView()
                .environmentObject(viewModel)
            #else
            ContentView(storeManager: storeManager)
                .environmentObject(viewModel)
                .onAppear {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIDs)
                }
            #endif
        }
    }
}
