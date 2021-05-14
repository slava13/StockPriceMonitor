//
//  ViewController.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 03/04/2021.
//

import Cocoa

final class ViewController: NSViewController {

    var onApply: ((String) -> Void)?
    
    // MARK: - Outlets
    @IBOutlet private weak var amountField: NSTextField!
    @IBOutlet private weak var applyButton: NSButton!
    
    // MARK: - Private
    private let formatter = OnlyIntegerValueFormatter()
    private let storage = UserDefaultsStorage(userDefaults: .standard)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        updateButton()
    }
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        updateButton()
    }
    
    func textField(_ textField: NSTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        allowOnlyIntegers(textField, string: string)
    }
}

private extension ViewController {
    
    @IBAction func apply(_ sender: Any) {
        onApply?(amountField.stringValue)
        storage.updateRsuAmount(amountField.stringValue)
    }
    
    func updateButton() {
        applyButton.isEnabled = amountField.stringValue.isEmpty == false
    }
    
    func setupTextField() {
        amountField.isEditable = true
        amountField.formatter = formatter
    }
}


