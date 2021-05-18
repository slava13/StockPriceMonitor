//
//  AppDelegate.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 03/04/2021.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let storage = UserDefaultsStorage(userDefaults: .standard)
    private let networkCall = NetworkCall()
    private let currencyStorage = CurrenciesStorage()
    private let calculator = Calculator()
    private let scheduler = Scheduler()
    private var presenter: Presenter?
    private var timer: APITimerCall?
    private var basicView: BasicInfoView?
    
    private lazy var settingsController: NSWindowController? =
        NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "WelcomeWindow")
        as? NSWindowController
    
    private lazy var preferencesViewController = PreferencesWindowController(network: networkCall,
                                                                             storage: storage,
                                                                             currencyStorage: currencyStorage)
    private lazy var preferencesWindow = NSWindow(contentViewController: preferencesViewController)
    
    
    private var viewController: ViewController? {
        return settingsController?.contentViewController as? ViewController
    }
    
    override init() {
        presenter = Presenter(storage: storage)
        timer = APITimerCall(networkCall: networkCall,
                             calculator: calculator,
                             scheduler: scheduler,
                             storage: storage)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if storage.isRsuAmountAvailable() {
            loadDataFromDefaults()
            timer?.startTimer(ignoreDate: false)
            presentData()
            constructMenu()
        } else {
            updateCurrency()
            fetchStockPrice()
            viewController?.onApply = { [self] value in
                let price = self.storage.getPrice()
                let percentage = self.storage.getPercentageChange()
                let sum = (price * Double(value)!).rounded(toPlaces: 2)
                self.presenter?.presentData(for: self.statusItem, result: sum, percentage: percentage)
                self.timer?.startTimer(ignoreDate: false)
                self.presentData()
                self.constructMenu()
                self.presenter?.onPresent = {
                    self.viewController?.view.window?.close()
                }
            }
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return statusItem.button?.title == "" ? true : false
    }
}

private extension AppDelegate {
    
    func constructMenu() {
        let menu = NSMenu()
        menu.delegate = self
        let firstItem = NSMenuItem()
        basicView = BasicInfoView(frame: NSRect(x: 0.0, y: 0.0, width: 308.0, height: 139))
        firstItem.view = basicView!
        menu.addItem(firstItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refresh(_:)), keyEquivalent: "r"))
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.preferencesWindow(_:)), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit StockPrice", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    @objc func preferencesWindow(_ sender: NSMenuItem) {
        preferencesWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        preferencesViewController.onApply = { self.restartAndPresent() }
        preferencesViewController.onExchange = { self.restartAndPresent() }
        preferencesViewController.onRefresh = { self.restartAndPresent() }
    }
    
    @objc func refresh(_ sender: NSMenuItem) {
        restartAndPresent()
    }
    
    func fetchStockPrice() {
        networkCall.fetchStockPrice { (result) in
            switch result {
            case .failure(let error):
                self.handleError(error.localizedDescription)
            case .success(let data):
                let percentageChange = self.calculator.calculatePercentageDiff(previousClose: data.pc,
                                                                               currentPrice: data.c)
                self.storage.updatePreferences(price: data.c,
                                               previousClose: data.pc,
                                               percentageChange: percentageChange,
                                               openPrice: data.o,
                                               highPrice: data.h,
                                               lowPrice: data.l)
                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                    self.settingsController?.showWindow(nil)
                }
            }
        }
    }
    
    // Probably, I could move it into a Timer and invoke it as else for timerCall
    func loadDataFromDefaults() {
        let percentage = storage.getPercentageChange()
        let rsuAmount = storage.getRsuAmount()
        let price = storage.getPrice()
        //I could load these data from defaults, but is it better to calculate it manually? hmm..
        let sum = (price * Double(rsuAmount)).rounded(toPlaces: 2)
        presenter?.presentData(for: statusItem, result: sum, percentage: percentage)
    }
    
    private func handleError(_ error: String) {
        DispatchQueue.main.async {
            let viewController = ErrorWindow(message: error)
            let preferencesWindow = NSWindow(contentViewController: viewController)
            preferencesWindow.makeKeyAndOrderFront(nil)
        }
    }
    
    private func updateCurrency() {
        guard let symbol = NSLocale.current.currencySymbol,
              let currency = NSLocale.current.currencyCode else { return }
        if currencyStorage.isValidCurrencyToExchange(currency) {
            exchangeCurrency(currency, symbol: symbol)
        }
    }
    
    private func exchangeCurrency(_ currency: String, symbol: String) {
        self.networkCall.getExchangeRate(for: currency) { (result) in
            switch result {
            case .failure(let error):
                self.handleError(error.localizedDescription)
            case .success(let data):
                let rates = data.rates
                guard let rate = rates[currency]?.rounded(toPlaces: 2) else { self.handleError("No currency for you"); return }
                self.storage.updateCurrencyInfo(currency, symbol: symbol, exchangeRate: rate.rounded(toPlaces: 2))
            }
        }
    }
    
    private func restartAndPresent() {
        self.timer?.restart()
        self.presentData()
    }
    
    private func presentData() {
        self.timer?.onFetch = { result, percentage in
            self.presenter?.presentData(for: self.statusItem, result: result.rounded(toPlaces: 2), percentage: percentage)
        }
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        let stockBasicInfo = BasicStockInfo(rsuAmount: storage.getRsuAmount(),
                                            price: storage.getPrice(),
                                            openPrice: storage.getOpenPrice(),
                                            highPrice: storage.getHighPrice(),
                                            lowPrice: storage.getLowPrice(),
                                            previousClose: storage.getPreviousClose())
        basicView?.showData(basicStockInfo: stockBasicInfo)
    }
}
