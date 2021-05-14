//
//  Double+Extensions.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 25/04/2021.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
