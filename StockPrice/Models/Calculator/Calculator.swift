//
//  Calculator.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 12/04/2021.
//

import Foundation

protocol Calculate {
    
    func calculatePercentageDiff(previousClose: Double?, currentPrice: Double?) -> String
    func calculateSumValue(currentPrice: Double?, rsuValue: Int?) -> Double
}

final class Calculator: Calculate {
    
    func calculatePercentageDiff(previousClose: Double?, currentPrice: Double?) -> String {
        guard let a = previousClose,
              let b = currentPrice else { return "" }
        let decrease = a - b
        let result = (decrease / a) * 100
        let absoluteValue = abs(result)
        return a > b ? "-\(absoluteValue.rounded(toPlaces: 2))%" : "+\(absoluteValue.rounded(toPlaces: 2))%"
    }
    
    func calculateSumValue(currentPrice: Double?, rsuValue: Int?) -> Double {
        guard let currentPrice = currentPrice,
              let rsuValue = rsuValue else { return 0 }
        return currentPrice * Double(rsuValue)
    }
}
