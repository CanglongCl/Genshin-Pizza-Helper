//
//  GachaModel.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/3/28.
//

import CoreData
import Foundation

extension GachaItemMO {
    public func toGachaItem() -> GachaItem {
        .init(
            uid: uid!,
            gachaType: .init(rawValue: Int(gachaType))!,
            itemId: itemId!,
            count: Int(count),
            time: time!,
            name: name!,
            lang: .init(rawValue: lang!)!,
            itemType: itemType!,
            rankType: .init(rawValue: Int(rankType))!,
            id: id!
        )
    }
}

extension GachaItem_FM {
    public func toGachaItemMO(context: NSManagedObjectContext) -> GachaItemMO {
        var item = self
        if item.lang != .zhCN {
            item.translateToZHCN()
        }
        let model = GachaItemMO(context: context)
        model.uid = item.uid
        model.gachaType = Int16(item.gachaType)!
        model.itemId = item.itemId
        model.count = Int16(item.count)!
        model.time = item.time
        model.name = item.name
        model.lang = item.lang.rawValue
        model.itemType = item.itemType
        model.rankType = Int16(item.rankType)!
        model.id = item.id
        return model
    }
}
