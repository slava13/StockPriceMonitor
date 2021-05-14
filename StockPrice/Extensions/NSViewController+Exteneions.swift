//
//  NSViewController+Exteneions.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 03/05/2021.
//

import Cocoa

extension NSViewController {
    
    func allowOnlyIntegers(_ textField: NSTextField, string: String ) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let withDecimal = (
            string == NumberFormatter().decimalSeparator &&
                textField.stringValue.contains(string) == false
        )
        return isNumber || withDecimal
    }
}
