//
//  EventHandler.swift
//  BrowserSwitcher
//
//  Created by mxa on 27.03.2019.
//  Copyright © 2019 0bmxa. All rights reserved.
//

import AppKit

internal class EventHandler {
    private let config: Configuration
    private let configFileManager: ConfigFileManager
    private weak var appDelegate: AppDelegate?

    init(appDelegate: AppDelegate, configFileManager: ConfigFileManager) {
        self.appDelegate = appDelegate
        self.configFileManager = configFileManager
        self.config = configFileManager.read()
    }

    /// Handles manual app launches.
    @objc
    func handleAppOpen(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        self.appDelegate?.handleAppOpen()
    }

    /// Handles launches via URL.
    @objc
    func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer { self.appDelegate?.suggestToQuitApp() }

        // Get URL from event
        guard var url = event.url else { return }

        // If current host is not in the list of exceptions, open default browser
        guard
            let host = url.host,
            let exception = self.config.exceptions.first(where: { $0.matches(host: host) })
        else {
            self.open(url: url, with: self.config.defaultBrowserBundleID)
            return
        }

        // Apply URL transformation, if defined
        url = exception.applyTransformation(to: url)

        // Open browser
        let browser = exception.browserBundleID ?? self.config.defaultBrowserBundleID
        self.open(url: url, with: browser)
    }

    /// Handles launches with a local document
    @objc
    func handleFileOpen(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // No matter how we exit, always close app
        defer { self.appDelegate?.suggestToQuitApp() }

        // Get URL from event
        guard let url = event.url else { return }

        // Open default browser
        self.open(url: url, with: self.config.defaultBrowserBundleID)
    }

    /// Handles requests to write the config file to disk.
    internal func handleConfigFileWrite() {
        let success = self.configFileManager.write(config: self.config, overwrite: false)
        if success {
            let url = self.configFileManager.userURL
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }

    /// Opens a URL in a specified browser
    @discardableResult
    private func open(url: URL, with browserBundleID: String) -> Bool {
        let success = NSWorkspace.shared.open(
            [url],
            withAppBundleIdentifier: browserBundleID,
            options: [.async],
            additionalEventParamDescriptor: nil,
            launchIdentifiers: nil
        )
        return success
    }
}
