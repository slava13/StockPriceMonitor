//
//  Presenter.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 16/04/2021.
//

import Cocoa

protocol Present {
    
    func presentData(for statusItem: NSStatusItem, result: Double, percentage: String)
}

class Presenter: Present {
    
    var onPresent: (() -> Void)?
    private let storage: UserDefaultsStorage
    
    init(storage: UserDefaultsStorage) {
        self.storage = storage
    }
    
    func presentData(for statusItem: NSStatusItem, result: Double, percentage: String) {
        if storage.isExchangeAvailable() {
            let exchangeRate = storage.getExchangeRate()
            guard let symbol = storage.getCurrencySymbol() else { print("No currency symbol"); return }
            let convertedResult = result * exchangeRate
            DispatchQueue.main.async {
                self.setupTitleAndColor(statusItem, price: "\(symbol)\(convertedResult.rounded(toPlaces: 2))", percentageChange: percentage)
            }
        } else {
            DispatchQueue.main.async {
                self.setupTitleAndColor(statusItem, price: "$\(result.rounded(toPlaces: 2))", percentageChange: percentage)
            }
        }
    }
}

private extension Presenter {
    
    func setupTitleAndColor(_ statusItem: NSStatusItem, price: String, percentageChange: String) {
        let attributePrice = [ NSAttributedString.Key.foregroundColor: NSColor.labelColor ]
        let attributeTitlePrice = NSMutableAttributedString(string: price, attributes: attributePrice)
        let color = percentageColor(percentageChange)
        let attributeTitlePercentage = NSMutableAttributedString(string: " (\(percentageChange))", attributes: color)
        statusItem.button?.attributedTitle = attributeTitlePrice + attributeTitlePercentage
        onPresent?()
    }
    
    private func percentageColor(_ percentageChange: String) -> [NSAttributedString.Key : NSColor] {
        return percentageChange.contains("+") ? [NSAttributedString.Key.foregroundColor: NSColor.systemGreen] : [NSAttributedString.Key.foregroundColor: NSColor.systemRed]
    }
}
