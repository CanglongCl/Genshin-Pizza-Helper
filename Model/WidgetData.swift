//
//  WidgetData.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/14.
//

import Foundation
import HBMihoyoAPI

enum WidgetDataKind {
    case normal(result: FetchResult)
    case simplified(result: SimplifiedUserDataResult)
}
