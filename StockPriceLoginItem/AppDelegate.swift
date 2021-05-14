//
//  AppDelegate.swift
//  StockPriceLoginItem
//
//  Created by Slava on 5/11/21.
//

import Cocoa


@NSApplicationMain
class HelperAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
            let isRunning = runningApps.contains {
                $0.bundleIdentifier == "com.badoo.StockPrice"
            }

            if !isRunning {
                var path = Bundle.main.bundlePath as NSString
                for _ in 1...4 {
                    path = path.deletingLastPathComponent as NSString
                }
                NSWorkspace.shared.launchApplication(path as String)
            }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

