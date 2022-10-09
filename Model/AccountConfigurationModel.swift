//
//  CoreDataModel.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/8/9.
//  基于CoreData配置帐号所需核心信息

import Foundation
import CoreData
import Intents

class AccountConfigurationModel {
    
    // CoreData
    
    static let shared: AccountConfigurationModel = AccountConfigurationModel()
    
    let container: NSPersistentCloudKitContainer
    
    private init() {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.GenshinPizzaHelper")!
        let storeURL = containerURL.appendingPathComponent("AccountConfiguration.splite")

        container = NSPersistentCloudKitContainer(name: "AccountConfiguration")
        let description = container.persistentStoreDescriptions.first!
        description.url = storeURL
        
        description.cloudKitContainerOptions = .init(containerIdentifier: "iCloud.com.Canglong.GenshinPizzaHepler")
        description.setOption(true as NSNumber, forKey: "NSPersistentStoreRemoteChangeNotificationOptionKey")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.viewContext.refreshAllObjects()
        
        // 尝试从UserDefault迁移数据
        if fetchAccountConfigs().isEmpty {
            migrateDataFromUserDefault()
        }
        
    }
    
    func fetchAccountConfigs() -> [AccountConfiguration] {
        // 从Core Data更新账号信息
        container.viewContext.refreshAllObjects()
        let request = NSFetchRequest<AccountConfiguration>(entityName: "AccountConfiguration")
        
        do {
            let accountConfigs = try container.viewContext.fetch(request)
            return accountConfigs
            
        } catch {
            print("ERROR FETCHING CONFIGURATION. \(error.localizedDescription)")
            return []
        }
        
    }
    
    func addAccount(name: String, uid: String, cookie: String, server: Server) {
        // 新增账号至Core Data
        let newAccount = AccountConfiguration(context: container.viewContext)
        newAccount.name = name
        newAccount.uid = uid
        newAccount.cookie = cookie
        newAccount.server = server
        newAccount.uuid = UUID()
        saveAccountConfigs()
    }
    
    func deleteAccount(account: Account) {
        container.viewContext.delete(account.config)
        saveAccountConfigs()
    }
    
    func saveAccountConfigs() {
        do {
            try container.viewContext.save()
        } catch {
            print("ERROR SAVING. \(error.localizedDescription)")
        }
    }
    
    fileprivate func migrateDataFromUserDefault() {
        // 迁移数据UserDefault
        if let userDefaults = UserDefaults(suiteName: "group.GenshinPizzaHelper") {
            if let name = userDefaults.string(forKey: "accountName"),
               let uid = userDefaults.string(forKey: "uid"),
               let cookie = userDefaults.string(forKey: "cookie"),
               var serverName = userDefaults.string(forKey: "server") {
                // 以上：如果UserDefault有存账号
                
                if serverName == "国服" { serverName = "天空岛"}
                if serverName == "B服" { serverName = "世界树" }
                
                addAccount(name: name, uid: uid, cookie: cookie, server: Server(rawValue: serverName)!)
                
                userDefaults.removeObject(forKey: "accountName")
                userDefaults.removeObject(forKey: "uid")
                userDefaults.removeObject(forKey: "cookie")
                userDefaults.removeObject(forKey: "server")
            }
        }
    }

    
}
