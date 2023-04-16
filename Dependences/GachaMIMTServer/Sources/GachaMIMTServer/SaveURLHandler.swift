//
//  File.swift
//  
//
//  Created by 戴藏龙 on 2023/4/1.
//

import Foundation
import SwiftUI
import RustXcframework
import UserNotifications

func gotURL(url: RustStr) {
    let urlString = url.toString()

    let APP_GROUP_IDENTIFIER: String = "group.GenshinPizzaHelper"
    let storage = UserDefaults(suiteName: APP_GROUP_IDENTIFIER)!

    let MIMT_URL_STORAGE_KEY: String = "mimtURLArray"
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    if let arrayJsonString = storage.string(forKey: MIMT_URL_STORAGE_KEY),
        !arrayJsonString.isEmpty,
       var urlStringArray = try? decoder.decode([String].self, from: arrayJsonString.data(using: .utf8)!) {

        urlStringArray.append(urlString)
        let toSave = String(data: try! encoder.encode(urlStringArray), encoding: .utf8)
        storage.set(toSave, forKey: MIMT_URL_STORAGE_KEY)

    } else {
        let urlStringArray: [String] = [urlString]
        let toSave = String(data: try! encoder.encode(urlStringArray), encoding: .utf8)
        storage.set(toSave, forKey: MIMT_URL_STORAGE_KEY)
    }

    let content = UNMutableNotificationContent()
    content.title = NSLocalizedString("title", bundle: .module, value: "fail find title", comment: "")
    content.body = NSLocalizedString("body", bundle: .module, value: "fail find body", comment: "")

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

    let uuidString = UUID().uuidString

    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request)

}
