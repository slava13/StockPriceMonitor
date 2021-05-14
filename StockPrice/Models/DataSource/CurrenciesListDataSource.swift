//
//  CurrenciesListDataSource.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 17/04/2021.
//

import AppKit

final class ComboBoxDataSource: NSObject, NSComboBoxCellDataSource, NSComboBoxDataSource, NSComboBoxDelegate {
    
    let currenciesStorage = CurrenciesStorage()
        
    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        print("SubString = \(string)")
        let currencies = currenciesStorage.onlyCurrencies()
        for key in currencies {
            if string.count < key.count{
                let statePartialStr = key.lowercased()[key.lowercased().startIndex..<key.lowercased().index(key.lowercased().startIndex, offsetBy: string.count)]
                if statePartialStr.range(of: string.lowercased()) != nil {
                    print("SubString Match = \(key)")
                    return key
                }
            }
        }
        return ""
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return currenciesStorage.onlyCurrencies().count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let currencies = currenciesStorage.onlyCurrencies()
        return(currencies[index] as AnyObject)
    }
    
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        let currencies = currenciesStorage.onlyCurrencies()
        var i = 0
        for str in currencies {
            if str == string {
                return i
            }
            i += 1
        }
        return -1
    }
}
