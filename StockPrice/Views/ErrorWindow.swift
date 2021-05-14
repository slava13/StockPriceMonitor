//
//  ErrorWindow.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 11/04/2021.
//

import Cocoa

class ErrorWindow: NSViewController {

    private let message: String
    
    init(message: String) {
        self.message = message
        super.init(nibName: "ErrorWindow", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Outlets
    @IBOutlet private var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.string = message
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window.map(updateWindow)
    }
    
}

private extension ErrorWindow {
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    func updateWindow(window: NSWindow) {
        window.styleMask.remove(.fullScreen)
        window.styleMask.remove(.resizable)
        window.styleMask.remove(.borderless)
        window.styleMask.remove(.titled)
        window.title = "Preferences"
    }
}
