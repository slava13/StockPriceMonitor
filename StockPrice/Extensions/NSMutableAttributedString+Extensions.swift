//
//  NSMutableAttributedString+Extensions.swift
//  StockPrice
//
//  Created by Slava on 5/9/21.
//

import Foundation

public extension NSAttributedString {
    
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }

    static func + (left: NSAttributedString, right: String) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        let rightAttr = NSMutableAttributedString(string: right)
        leftCopy.append(rightAttr)
        return leftCopy
    }

    static func + (left: String, right: NSAttributedString) -> NSAttributedString {
        let leftAttr = NSMutableAttributedString(string: left)
        leftAttr.append(right)
        return leftAttr
    }
}

public extension NSMutableAttributedString {
    
    static func += (left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
        let rightAttr = NSMutableAttributedString(string: right)
        left.append(rightAttr)
        return left
    }

    static func += (left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
}
