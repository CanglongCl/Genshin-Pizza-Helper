//
//  NumberTools.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/9/24.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
