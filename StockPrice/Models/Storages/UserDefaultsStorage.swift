//
//  UserDefaultsInjectable.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 06/04/2021.
//

import AppKit

class UserDefaultsStorage {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func updateRsuAmount(_ amount: String) {
        let data = amount.data(using: .utf8)
        userDefaults.setValue(data, forKey: .rsuAmount)
    }
    
    func getRsuAmount() -> Int {
        let data = userDefaults.data(forKey: .rsuAmount)
        guard let amount = data,
              let rsu = String(data: amount, encoding: .utf8),
              let rsuAmount = Int(rsu) else { return 0 }
        return rsuAmount
    }
    
    func updatePrice(price: Double) {
        userDefaults.setValue(price.rounded(toPlaces: 2), forKey: .price)
    }
    
    func getPrice() -> Double {
        return userDefaults.double(forKey: .price)
    }
    
    func updatePreviousClose(_ previousClosePrice: Double) {
        userDefaults.setValue(previousClosePrice.rounded(toPlaces: 2), forKey: .previousClose)
    }
    
    func getPreviousClose() -> Double {
        return userDefaults.double(forKey: .previousClose).rounded(toPlaces: 2)
    }
    
    func updateHighPrice(_ highPrice: Double) {
        userDefaults.setValue(highPrice.rounded(toPlaces: 2), forKey: .highPrice)
    }
    
    func getHighPrice() -> Double {
        return userDefaults.double(forKey: .highPrice).rounded(toPlaces: 2)
    }
    
    func updateLowPrice(_ lowPrice: Double) {
        userDefaults.setValue(lowPrice.rounded(toPlaces: 2), forKey: .lowPrice)
    }
    
    func getLowPrice() -> Double {
        return userDefaults.double(forKey: .lowPrice).rounded(toPlaces: 2)
    }
    
    func updateOpenPrice(_ openPrice: Double) {
        userDefaults.setValue(openPrice.rounded(toPlaces: 2), forKey: .openPrice)
    }
    
    func getOpenPrice() -> Double {
        return userDefaults.double(forKey: .openPrice).rounded(toPlaces: 2)
    }
    
    func updatePercentageChange(_ percentageChange: String) {
        userDefaults.setValue(percentageChange, forKey: .percentageChange)
    }
    
    func getPercentageChange() -> String {
        // тупо, но пусть пока так будет
        guard let percentageChange = userDefaults.string(forKey: .percentageChange) else { return "0" }
        return percentageChange
    }
    
    func updateSumValue(_ sum: Double) {
        let data = withUnsafeBytes(of: sum.rounded(toPlaces: 2)) { Data($0) }
        userDefaults.setValue(data, forKey: .sum)
    }
    
    func getSumValue() -> Double {
        let data = userDefaults.data(forKey: .sum)
        guard let amount = data,
              let sum = String(data: amount, encoding: .utf8),
              let sumAmount = Double(sum) else { return 0 }
        return sumAmount
    }
    
    func updateCurrencySymbol(_ symbol: String) {
        userDefaults.setValue(symbol, forKey: .currencySymbol)
    }
    
    func getCurrencySymbol() -> String? {
        guard let symbol = userDefaults.string(forKey: .currencySymbol) else { return nil }
        return symbol
    }
    
    func updateExchangeRate(_ rate: Double) {
        userDefaults.setValue(rate, forKey: .exchangeRate)
    }
    
    func updateCurrency(_ currency: String) {
        userDefaults.setValue(currency, forKey: .currency)
    }
    
    func getCurrency() -> String? {
        return userDefaults.string(forKey: .currency)
    }
    
    func getExchangeRate() -> Double {
        return userDefaults.double(forKey: .exchangeRate)
    }
    
    func isExchangeAvailable() -> Bool {
        return isKeyExists(key: .currencySymbol) && isKeyExists(key: .exchangeRate) && isNotUSDCurrency(key: .currency)
    }
    
    func isRsuAmountAvailable() -> Bool {
        return isKeyExists(key: .rsuAmount)
    }
    
    func updateCurrencyInfo(_ currency: String?, symbol: String?, exchangeRate: Double?) {
        guard let currency = currency,
              let symbol = symbol,
              let exchangeRate = exchangeRate else { return }
        updateCurrency(currency)
        updateCurrencySymbol(symbol)
        updateExchangeRate(exchangeRate)
    }
    
    func updatePreferences(price: Double, previousClose: Double, percentageChange: String,
                           openPrice: Double, highPrice: Double, lowPrice: Double) {
        updatePrice(price: price)
        updatePreviousClose(previousClose)
        updatePercentageChange(percentageChange)
        updateOpenPrice(openPrice)
        updateHighPrice(highPrice)
        updateLowPrice(lowPrice)
    }
}

private extension UserDefaultsStorage {
    
    func isKeyExists(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    func isNotUSDCurrency(key: String) -> Bool {
        return userDefaults.string(forKey: key) != "USD"
    }
    
}

private extension String {
    
    static let rsuAmount = "RsuAmount"
    static let price = "Price"
    static let previousClose = "PreviousClose"
    static let percentageChange = "PercentageChange"
    static let sum = "Sum"
    static let currencySymbol = "CurrencySymbol"
    static let exchangeRate = "ExchangeRate"
    static let currency = "Currency"
    static let highPrice = "HighPrice"
    static let lowPrice = "LowPrice"
    static let openPrice = "OpenPrice"
}
