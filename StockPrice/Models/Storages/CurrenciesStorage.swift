//
//  CurrenciesStorage.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 06/05/2021.
//

import Cocoa

protocol CurrenciesStorageActions {
    func symbolForCurrency(_ currency: String) -> String?
    func isValidCurrencyToExchange(_ currency: String) -> Bool
    func onlyCurrencies() -> [String]
}

struct CurrenciesStorage: CurrenciesStorageActions {
    
    private let currenciesAndSymbols = ["GBP" : "£", "HKD" : "HK$","IDR" : "Rp", "ILS": "₪", "DKK": "Dkr", "INR": "Rs", "CHF": "CHF", "MXN": "MX$", "CZK": "Kč", "SGD": "S$", "THB": "฿", "HRK": "kn", "EUR": "€", "MYR": "RM", "NOK": "Nkr", "CNY": "CN¥", "BGN": "BGN", "PHP": "₱", "PLN": "zł", "ZAR": "R", "CAD": "CA$", "ISK": "Ikr", "BRL": "R$", "RON": "RON", "NZD": "NZ$", "TRY": "TL", "JPY": "¥", "RUB": "₽", "KRW": "₩", "USD": "$", "AUD": "AU$", "HUF": "Ft", "SEK": "Skr"]
    
    func symbolForCurrency(_ currency: String) -> String? {
        currenciesAndSymbols.contains { $0.key == currency } ? currenciesAndSymbols[currency] : nil
    }
    
    func isValidCurrencyToExchange(_ currency: String) -> Bool {
        return currenciesAndSymbols.contains { $0.key == currency }
    }
    
    func onlyCurrencies() -> [String] {
        return currenciesAndSymbols.keys.sorted(by: <)
    }
}
