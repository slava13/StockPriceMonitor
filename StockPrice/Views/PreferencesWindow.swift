//
//  PreferencesWindow.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 10/04/2021.
//

import Cocoa
import ServiceManagement

class PreferencesWindowController: NSViewController {
    
    var onApply: (() -> Void)?
    var onRefresh: (() -> Void)?
    var onExchange: (() -> Void)?
    
    // MARK: - Outlets
    @IBOutlet private weak var rsuAmount: NSTextField!
    @IBOutlet private weak var spinner: NSProgressIndicator!
    @IBOutlet private weak var exchange: NSButton!
    @IBOutlet private weak var comboBox: NSComboBox!
    @IBOutlet private weak var applyButton: NSButton!
    @IBOutlet private weak var autoLaunchCheckbox: NSButton!
    
    // MARK: - Private
    private let formatter = OnlyIntegerValueFormatter()
    private let currencyStorage: CurrenciesStorage
    private let network: NetworkCall
    private let storage: UserDefaultsStorage
    private let helperBundleID: String = .helperBundleID
    
    init(network: NetworkCall, storage: UserDefaultsStorage, currencyStorage: CurrenciesStorage) {
        self.network = network
        self.storage = storage
        self.currencyStorage = currencyStorage
        super.init(nibName: .preferencesWindow, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rsuAmount.formatter = formatter
        spinner.isHidden = true
        updateButton()
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleID
        }
        autoLaunchCheckbox.state = foundHelper ? .on : .off
    }
    
    override func viewDidAppear() {
        rsuAmount.stringValue.removeAll()
        comboBox.stringValue.removeAll()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let window = view.window else { return }
        updateWindow(window: window)
    }
}

extension PreferencesWindowController: NSTextFieldDelegate, NSComboBoxDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        updateButton()
    }
    
    func textField(_ textField: NSTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        allowOnlyIntegers(textField, string: string)
    }
    
    private func updateButton() {
        applyButton.isEnabled = rsuAmount.stringValue.isEmpty == false
        updateExchangeButton()
    }
    
    private func updateWindow(window: NSWindow) {
        window.styleMask.remove(.fullScreen)
        window.styleMask.remove(.resizable)
        window.styleMask.remove(.borderless)
        window.title = "Preferences"
    }
}

private extension PreferencesWindowController {
    
    @IBAction func apply(_ sender: Any) {
        storage.updateRsuAmount(rsuAmount.stringValue)
        onApply?()
    }
    
    @IBAction func refresh(_ sender: Any) {
        onRefresh?()
    }
    
    @IBAction func selectComboBox(_ sender: Any) {
        updateExchangeButton()
    }
    
    @IBAction func exchange(_ sender: Any) {
        enableAnimation()
        let currency = comboBox.stringValue
        guard let symbol = currencyStorage.symbolForCurrency(currency) else { handleError(.symbolError + currency, buttonText: .okButton); return }
        if currencyStorage.isValidCurrencyToExchange(currency) {
            storage.updateCurrency(currency)
            storage.updateCurrencySymbol(symbol)
            self.onExchange?()
            self.disableAnimation()
        } else {
            showAlert(text: .currencyError + currency, button: .okButton)
        }
    }
    
    @IBAction func toggleAutoLaunch(_ sender: NSButton) {
        let isAuto = sender.state == .on
        SMLoginItemSetEnabled(helperBundleID as CFString, isAuto)
    }
    
    func showAlert(text: String, button title: String) {
        let nsAlert = NSAlert()
        nsAlert.informativeText = text
        nsAlert.addButton(withTitle: title)
        nsAlert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                return
            }
        })
    }
    
    func enableAnimation() {
        spinner.isHidden = false
        spinner.startAnimation(self)
        exchange.isEnabled = false
    }
    
    func disableAnimation() {
        DispatchQueue.main.async {
            self.spinner.stopAnimation(self)
            self.spinner.isHidden = true
            self.exchange.isEnabled = true
        }
    }
    
    func handleError(_ text: String, buttonText: String) {
        DispatchQueue.main.async {
            self.showAlert(text: text, button: buttonText)
            self.disableAnimation()
        }
    }
    
    func updateExchangeButton() {
        exchange.isEnabled = comboBox.stringValue.isEmpty == false
    }
}

private extension String {
    
    static let symbolError = "ERROR: Can't load symbol for your currency: "
    static let currencyError = "ERROR: Can't exchange for your currency: "
    static let loadError = "ERROR: Can't load exchange data for your currency: "
    static let okButton = "Ok"
    static let exchangeRateNilError = "ERROR: It seems like an exchange rate for your currency is NIL."
    static let preferencesWindow = "PreferencesWindow"
    static let helperBundleID = "com.badoo.StockPriceLoginItem"
}
