//
//  AppDelegate.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Carbon
import Cocoa

@NSApplicationMain
internal class AppDelegate: NSObject, NSApplicationDelegate {
    private var eventHandler: EventHandler?
    private var appWasLaunchedManually: Bool = false
    private let configFileManager = ConfigFileManager()

    @IBOutlet private var windowController: MainWindowController?

    func applicationWillFinishLaunching(_ notification: Notification) {
        // Load config from disk
        let eventHandler = EventHandler(appDelegate: self, configFileManager: configFileManager)
        self.eventHandler = eventHandler

        NSAppleEventManager.shared().setEventHandler(
            eventHandler,
            andSelector: #selector(eventHandler.handleAppOpen),
            forEventClass: kCoreEventClass,
            andEventID: kAEOpenApplication
        )
        NSAppleEventManager.shared().setEventHandler(
            eventHandler,
            andSelector: #selector(eventHandler.handleGetURLEvent),
            forEventClass: kAEInternetEventClass,
            andEventID: kAEGetURLEventID
        )
        NSAppleEventManager.shared().setEventHandler(
            eventHandler,
            andSelector: #selector(eventHandler.handleFileOpen),
            forEventClass: kCoreEventClass,
            andEventID: kAEOpenDocuments
        )
    }

    /// Handles manual app launches
    func handleAppOpen() {
        self.appWasLaunchedManually = true
        self.windowController?.configFileManager = self.configFileManager
        self.windowController?.showWindow()

        if !self.isDefaultBrowser() {
            self.registerDefaultBrowser()
        }
    }

    /// Quits the app, if it was lanuched from an event
    internal func suggestToQuitApp() {
        if !appWasLaunchedManually {
            NSApp.terminate(nil)
        }
    }

    /// Registers the app as default handler for http: and https: url schemes
    internal func registerDefaultBrowser() {
        guard let bundleID = Bundle.main.bundleIdentifier
            else { assertionFailure(); return }

        LSSetDefaultHandlerForURLScheme("http"  as CFString, bundleID as CFString)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleID as CFString)
    }

    /// Checks whether the app is registered as default handler
    /// for http: and https: url schemes
    internal func isDefaultBrowser() -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier
            else { assertionFailure(); return false }

        let defaultHTTPHandler =
            LSCopyDefaultHandlerForURLScheme("http" as CFString)?.takeRetainedValue()
        let defaultHTTPSHandler =
            LSCopyDefaultHandlerForURLScheme("https" as CFString)?.takeRetainedValue()

        let cfBundleID = bundleID as CFString
        return (defaultHTTPHandler == cfBundleID) && (defaultHTTPSHandler == cfBundleID)
    }
}
