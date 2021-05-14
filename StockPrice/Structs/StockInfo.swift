//
//  StockInfo.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 03/04/2021.
//

import Foundation

struct StockInfo: Codable {
    var c: Double
    var h: Double
    var l: Double
    var o: Double
    var pc: Double
    var t: Double
}

struct ExchangeRate: Codable {
    let base: String
    let rates: [String : Double]
    let date: String
}

struct BasicStockInfo {
    var rsuAmount: Int
    var price: Double
    var openPrice: Double
    var highPrice: Double
    var lowPrice: Double
    var previousClose: Double
}
