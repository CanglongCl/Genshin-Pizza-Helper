//
//  CollectionChunked.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/4/7.
//

import Foundation

extension Collection {
    public func chunked(into size: Int) -> [[Self.Element]] where Self.Index == Int {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }
}
