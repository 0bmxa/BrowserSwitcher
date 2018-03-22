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
    
    var config: Configuration = Configuration.fromDisk

    func applicationWillFinishLaunching(_ notification: Notification) {
        
        // Some custom config
        let spotify = Browser(bundleIdentifier: "com.spotify.client")
        self.config = Configuration(defaultBrowser: .safari, exceptions: [
            ExceptionHost(host: "*.google.com", browser: .chrome, transformation: nil),
            ExceptionHost(host: "app.asana.com", browser: .chrome, transformation: nil),
            ExceptionHost(host: "open.spotify.com", browser: spotify, transformation: (search: "https://open.spotify.com/", replace: "spotify:")),
        ])
        
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
}


// MARK: - URL opening
extension AppDelegate {
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer { NSApp.terminate(nil) }
        
        // Get URL from event
        guard
            let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            var url = URL(string: urlString)
        else { return }
        
        // If current host is not in the list of exceptions, open default browser
        guard let host = url.host, let specialURL = self.config.exceptions.first(where: { $0.hostEquals(host) }) else {
            self.open(url: url, with: self.config.defaultBrowser)
            return
        }
        
        
        // Apply URL transformation, if defined
        if let transformation = specialURL.transformation {
            let newURLString = urlString.replacingOccurrences(of: transformation.search, with: transformation.replace)
            if let newURL = URL(string: newURLString) {
                url = newURL
            }
        }
        
        // Open browser
        self.open(url: url, with: specialURL.browser)
    }
    
    
    /// Opens a URL in a specified browser
    private func open(url: URL, with browser: Browser) {
        NSWorkspace.shared.open([url], withAppBundleIdentifier: browser.bundleIdentifier, options: [.async], additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    }
}
