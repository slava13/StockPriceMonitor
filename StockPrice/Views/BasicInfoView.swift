//
//  BasicInfoView.swift
//  StockPrice
//
//  Created by Slava on 5/9/21.
//

import Cocoa

class BasicInfoView: NSView, LoadableView {

    
    @IBOutlet private weak var rsuAmountLabel: NSTextField!
    @IBOutlet private weak var openPriceLabel: NSTextField!
    @IBOutlet private weak var highPriceLabel: NSTextField!
    @IBOutlet private weak var lowPriceLabel: NSTextField!
    @IBOutlet private weak var previousCloseLabel: NSTextField!
    @IBOutlet private weak var priceLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "BasicInfoView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showData(basicStockInfo: BasicStockInfo) {
        rsuAmountLabel.stringValue = "\(basicStockInfo.rsuAmount)"
        priceLabel.stringValue = "$\(basicStockInfo.price)"
        openPriceLabel.stringValue = "$\(basicStockInfo.openPrice)"
        highPriceLabel.stringValue = "$\(basicStockInfo.highPrice)"
        lowPriceLabel.stringValue = "$\(basicStockInfo.lowPrice)"
        previousCloseLabel.stringValue = ("$\(basicStockInfo.previousClose)")
    }
    
}
