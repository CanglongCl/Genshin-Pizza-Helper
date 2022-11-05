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
    @Published var showCharacterDetailOfAccount: Account?
    @Published var showingCharacterName: String?

    #if !os(watchOS)
    var charLoc: [String : String]?
    var charMap: [String: ENCharacterMap.Character]?
    #endif

    let accountConfigurationModel: AccountConfigurationModel = .shared

//    var session: WCSession
    
    init(session: WCSession = .default) {
//        self.session = session
        super.init()
//        self.session.delegate = self
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
                #if !os(watchOS)
                if let showingPlayerDetailOfAccountUUID = UserDefaults.standard.string(forKey: "toolViewShowingAccountUUIDString"),
                   let showingPlayerDetailOfAccount = self.accounts.first(where: { account in
                       account.config.uuid!.uuidString == showingPlayerDetailOfAccountUUID
                   }) {
                    self.refreshPlayerDetail(for: showingPlayerDetailOfAccount)
                }
                self.refreshLedgerData()
                #endif
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
        accounts.removeAll {
            account == $0
        }
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
        }
        refreshAbyssAndBasicInfo()
    }

    func refreshAbyssAndBasicInfo() {
        accounts.indices.forEach { index in
            #if !os(watchOS)
            let group = DispatchGroup()
            group.enter()
            accounts[index].config.fetchBasicInfo { basicInfo in
                self.accounts[index].basicInfo = basicInfo
                self.accounts[index].uploadHoldingData()
                group.leave()
            }
            group.enter()
            self.accounts[index].config.fetchAbyssInfo { data in
                self.accounts[index].spiralAbyssDetail = data
                group.leave()
            }
            group.notify(queue: .main) {
                self.accounts[index].uploadAbyssData()
            }
            #endif
        }
    }

    #if !os(watchOS)
    func refreshPlayerDetail(for account: Account) {
        guard let index = self.accounts.firstIndex(of: account) else { return }
        // 如果之前返回了错误，则删除fail的result
        if let result = self.accounts[index].playerDetailResult, (try? result.get()) == nil {
            self.accounts[index].playerDetailResult = nil
        }
        self.accounts[index].fetchPlayerDetailComplete = false
        if let charLoc = self.charLoc, let charMap = self.charMap {
            self.accounts[index].config.fetchPlayerDetail(dateWhenNextRefreshable: try? self.accounts[index].playerDetailResult?.get().nextRefreshableDate) { result in
                switch result {
                case .success(let model):
                    self.accounts[index].playerDetailResult = .success(.init(playerDetailFetchModel: model, localizedDictionary: charLoc, characterMap: charMap))
                case .failure(let error):
                    if self.accounts[index].playerDetailResult == nil {
                        self.accounts[index].playerDetailResult = .failure(error)
                    }
                }
                self.accounts[index].fetchPlayerDetailComplete = true
            }
        } else {
            let group = DispatchGroup()
            group.enter()
            API.HomeAPIs.fetchENCharacterLocDatas {
                self.charLoc = $0.getLocalizedDictionary()
                group.leave()
            }
            group.enter()
            API.HomeAPIs.fetchENCharacterDetailDatas {
                self.charMap = $0.characterDetails
                group.leave()
            }
            group.notify(queue: .main) {
                guard let charLoc = self.charLoc else {
                    self.accounts[index].playerDetailResult = .failure(.failToGetLocalizedDictionary)
                    self.accounts[index].fetchPlayerDetailComplete = true
                    return
                }
                guard let charMap = self.charMap else {
                    self.accounts[index].playerDetailResult = .failure(.failToGetCharacterDictionary)
                    self.accounts[index].fetchPlayerDetailComplete = true
                    return
                }
                self.accounts[index].config.fetchPlayerDetail(dateWhenNextRefreshable: try? self.accounts[index].playerDetailResult?.get().nextRefreshableDate) { result in
                    switch result {
                    case .success(let model):
                        self.accounts[index].playerDetailResult = .success(.init(playerDetailFetchModel: model, localizedDictionary: charLoc, characterMap: charMap))
                    case .failure(let error):
                        if self.accounts[index].playerDetailResult == nil {
                            self.accounts[index].playerDetailResult = .failure(error)
                        }
                    }
                    self.accounts[index].fetchPlayerDetailComplete = true
                }
            }
        }
    }

    func refreshLedgerData() {
        accounts.indices.forEach { index in
            self.accounts[index].config.fetchLedgerData { result in
                self.accounts[index].ledgeDataResult = result
            }
        }
    }
    #endif
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
