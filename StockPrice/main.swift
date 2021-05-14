//
//  main.swift
//  StockPrice
//
//  Created by Slava on 5/11/21.
//

import Cocoa

func isRunningTests() -> Bool {
    let environment = ProcessInfo.processInfo.environment
    return environment["XCInjectBundleInto"] != nil || environment["XCInjectBundle"] != nil
}

if isRunningTests() {
    NSApplication.shared.delegate = nil
    NSApp.run()
} else {
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}
