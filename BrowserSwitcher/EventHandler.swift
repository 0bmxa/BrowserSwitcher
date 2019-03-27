//
//  EventHandler.swift
//  BrowserSwitcher
//
//  Created by mxa on 27.03.2019.
//  Copyright © 2019 0bmxa. All rights reserved.
//

import AppKit

class EventHandler {
    private let config: Configuration
    private weak var appDelegate: AppDelegate?
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        
        // Load config from disk (not working yet, as never saved)
        //self.config = Configuration.fromDisk
        
        // Some custom config
        let spotify = Browser(bundleIdentifier: "com.spotify.client")
        let exceptions: [ExceptionHost] = [
            ExceptionHost(host: "*.google.com", browser: .chrome),
            ExceptionHost(host: "goo.gl", browser: .chrome),
            ExceptionHost(host: "open.spotify.com", browser: spotify, transformation: (search: "https://open.spotify.com/", replace: "spotify:")),
            ExceptionHost(host: "m.facebook.com", transformation: (search: "m.facebook.com", replace: "facebook.com"))
        ]
        self.config = Configuration(defaultBrowser: .firefox, exceptions: exceptions)
    }

    
    /// Handles manual app launches
    @objc func handleAppOpen(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        self.appDelegate?.showWindow()
    }

    /// Handles launches via URL
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer { self.appDelegate?.suggestToQuitApp() }
        
        // Get URL from event
        guard
            let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            var url = URL(string: urlString)
            else { return }
        
        // If current host is not in the list of exceptions, open default browser
        guard
            let host = url.host,
            let exception = self.config.exceptions.first(where: { $0.hostEquals(host) })
            else {
                self.open(url: url, with: self.config.defaultBrowser)
                return
        }
        
        
        // Apply URL transformation, if defined
        if let transformation = exception.transformation {
            let newURLString = urlString.replacingOccurrences(of: transformation.search, with: transformation.replace)
            if let newURL = URL(string: newURLString) {
                url = newURL
            }
        }
        
        // Open browser
        let browser = exception.browser ?? self.config.defaultBrowser
        self.open(url: url, with: browser)
    }
    
    /// Handles launches with a local document
    @objc func handleFileOpen(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer { self.appDelegate?.suggestToQuitApp() }
        
        // Get URL from event
        guard
            let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: urlString)
            else { return }
        
        // Open default browser
        self.open(url: url, with: self.config.defaultBrowser)
    }
    
    
    /// Opens a URL in a specified browser
    private func open(url: URL, with browser: Browser) {
        NSWorkspace.shared.open([url], withAppBundleIdentifier: browser.bundleIdentifier, options: [.async], additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    }
}
