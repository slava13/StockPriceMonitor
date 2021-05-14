//
//  OnlyIntegerValueFormatter.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 06/04/2021.
//

import AppKit

class OnlyIntegerValueFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        if partialString.numberOfCharacters() == 0  {
            return true
        }
        
        if partialString.isInt() {
            return true
        } else {
            NSSound.beep()
            return false
        }
    }
}

extension String {

    func isInt() -> Bool {

        if let intValue = Int(self) {
            if intValue > 0 {
                return true
            }
        }
        return false
    }
    
    func numberOfCharacters() -> Int {
        return self.count
    }
}
