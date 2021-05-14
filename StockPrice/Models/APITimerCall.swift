//
//  APITimerCall.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 05/04/2021.
//

import AppKit
class APITimerCall {
        
    var onFetch: ((Double, String) -> Void)?
    
    private var timer: DispatchSourceTimer?
    private let networkCall: NetworkCall
    private let calculator: Calculator
    private let scheduler: Scheduler
    private let storage: UserDefaultsStorage
    
    init(networkCall: NetworkCall, calculator: Calculator, scheduler: Scheduler, storage: UserDefaultsStorage) {
        self.networkCall = networkCall
        self.calculator = calculator
        self.scheduler = scheduler
        self.storage = storage
    }
    
    func startTimer(ignoreDate: Bool) {
        let queue = DispatchQueue(label: "com.firm.app.timer", attributes: .concurrent)
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.setEventHandler { [weak self] in // `[weak self]` only needed if you reference `self` in this closure and you want to prevent strong reference cycle
            guard let self = self else { return }
            let timeToFetch = self.scheduler.isTimeToFetch(ignoreDate: ignoreDate)
            // It's not the best way to check the internet connection, but it's fine for my case
            if timeToFetch && Connectivity.isConnectedToInternet {
                self.startFetchingStockData(networkCall: self.networkCall)
                self.exchangeCurrency(networkCall: self.networkCall)
            }
        }
        timer?.schedule(deadline: .now(), repeating: .seconds(3600), leeway: .never)
        
        timer?.resume()
    }
    
    func stopTimer() {
        timer = nil
    }
}


extension APITimerCall {
    
    public func restart() {
        stopTimer()
        startTimer(ignoreDate: true)
    }
    
    private func startFetchingStockData(networkCall: NetworkCall) {
        self.networkCall.fetchStockPrice { (result) in
            switch result {
            case .failure(let error):
                self.handleError(error.localizedDescription)
            case .success(let data):
                let rsuValue = self.storage.getRsuAmount()
                let result = self.calculator.calculateSumValue(currentPrice: data.c, rsuValue: rsuValue)
                let percentageChange = self.calculator.calculatePercentageDiff(previousClose: data.pc, currentPrice: data.c)
                self.storage.updatePreferences(price: data.c, previousClose: data.pc, percentageChange: percentageChange, openPrice: data.o, highPrice: data.h, lowPrice: data.l)
                self.onFetch?(result, percentageChange)
            }
        }
    }
    
    private func exchangeCurrency(networkCall: NetworkCall) {
        if storage.isExchangeAvailable() {
            guard let currency = storage.getCurrency() else { return }
            networkCall.getExchangeRate(for: currency) { (result) in
                switch result {
                case .failure(let error):
                    self.handleError(error.localizedDescription)
                case .success(let data):
                    let rates = data.rates
                    guard let rate = rates[currency]?.rounded(toPlaces: 2) else { self.handleError(.exchangeRateNilError); return }
                    self.storage.updateExchangeRate(rate)
                }
            }
        }
    }
    
    private func handleError(_ error: String) {
        DispatchQueue.main.async {
            let viewController = ErrorWindow(message: error)
            let errorWindow = NSWindow(contentViewController: viewController)
            errorWindow.makeKeyAndOrderFront(nil)
        }
    }
}

private extension String {
    // I have the same constants in PreferencesWindowController. Perhaps, unify
    static let exchangeRateNilError = "ERROR: It seems like an exchange rate for your currency is NIL."
}
