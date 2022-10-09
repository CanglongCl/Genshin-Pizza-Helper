//
//  Model.swift
//  Genshin Resin Checker
//
//  Created by 戴藏龙 on 2022/7/12.
//  View中用于加载信息的工具类

import Foundation
import SwiftUI
import CoreData
import StoreKit
import WatchConnectivity

@MainActor
class ViewModel: NSObject, ObservableObject {
    
    static let shared = ViewModel()
    
    @Published var accounts: [Account] = []

    @Published var showDetailOfAccount: Account?
    
    let accountConfigurationModel: AccountConfigurationModel = .shared

    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
//        session.activate()
        self.fetchAccount()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchAccount),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: accountConfigurationModel.container.persistentStoreCoordinator)
    }
    
    @objc
    func fetchAccount() {
        // 从Core Data更新账号信息
        // 检查是否有更改，如果有更改则更新
        DispatchQueue.main.async {
            let accountConfigs = self.accountConfigurationModel.fetchAccountConfigs()

            if !self.accounts.isEqualTo(accountConfigs) {
                self.accounts = accountConfigs.map { Account(config: $0) }
                self.refreshData()
                print("account fetched")
            }
        }
    }
    
    func forceFetchAccount() {
        // 强制从云端Core Data更新账号信息
        accounts = accountConfigurationModel.fetchAccountConfigs().map { Account(config: $0) }
        self.refreshData()
        print("force account fetched")
    }
    
    func addAccount(name: String, uid: String, cookie: String, server: Server) {
        // 新增账号至Core Data
        accountConfigurationModel.addAccount(name: name, uid: uid, cookie: cookie, server: server)
        fetchAccount()
    }
    
    func deleteAccount(account: Account) {
        accountConfigurationModel.deleteAccount(account: account)
        fetchAccount()
    }
    
    func saveAccount() {
        accountConfigurationModel.saveAccountConfigs()
        fetchAccount()
    }
    
    
    func refreshData() {
        accounts.indices.forEach { index in
            accounts[index].fetchComplete = false
            accounts[index].config.fetchResult { result in
                self.accounts[index].result = result
                self.accounts[index].background = .randomNamecardBackground
                self.accounts[index].fetchComplete = true
            }
            accounts[index].config.fetchBasicInfo { basicInfo in
                self.accounts[index].basicInfo = basicInfo
            }
        }
    }
}

extension ViewModel: WCSessionDelegate {
    #if !os(watchOS)
    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
    #endif

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("The session has completed activation.")
            }
        }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            let accounts = message["accounts"] as? [Account]
            print(accounts == nil ? "data nil" : "data received")
            self.accounts = accounts ?? []
        }
    }
}

extension Array where Element == Account {
    func isEqualTo(_ newAccountConfigs: [AccountConfiguration]) -> Bool {
        if (self.count == 0) && (newAccountConfigs.count == 0) { return true }
        if self.count != newAccountConfigs.count { return false }
        
        var isSame = true
        
        self.forEach { account in
            guard let uuid = account.config.uuid else { isSame = false; return }
            guard let compareAccount = (newAccountConfigs.first { $0.uuid == uuid }) else { isSame = false; return }
            if !(compareAccount.uid == account.config.uid && compareAccount.cookie == account.config.cookie && compareAccount.server == account.config.server) { isSame = false }
        }
        
        newAccountConfigs.forEach { config in
            guard let uuid = config.uuid else { isSame = false; return }
            guard let compareAccount = (self.first { $0.config.uuid == uuid }?.config) else { isSame = false; return }
            if !(compareAccount.uid == config.uid && compareAccount.cookie == config.cookie && compareAccount.server == config.server) { isSame = false }
        }
        
        return isSame
    }
}
