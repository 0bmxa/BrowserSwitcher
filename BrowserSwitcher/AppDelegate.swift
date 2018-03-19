//
//  AppDelegate.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    
    let config = Configuration(defaultBrowser: .safari, alternativeBrowser: .chrome, exceptionURLs: [
        "drive.google.com",
        "calendar.google.com",
    ])

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
}


// MARK: - URL opening
extension AppDelegate {
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer {
            NSApp.terminate(nil)
        }
        
        // Get URL
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let url = URL(string: urlString)
        else { return }

        let browser: Browser
        // Check if current URL is in the exception list and select browser accordingly
        if let host = url.host, self.config.exceptionURLs.contains(host) {
            browser = self.config.alternativeBrowser
        } else {
            browser = self.config.defaultBrowser
        }

        // Open browser
        NSWorkspace.shared.open([url], withAppBundleIdentifier: browser.bundleIdentifier, options: [.async], additionalEventParamDescriptor: event, launchIdentifiers: nil)
    }
}
