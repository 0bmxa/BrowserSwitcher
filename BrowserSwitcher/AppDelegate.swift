//
//  AppDelegate.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private weak var window: NSWindow!
    
    private var eventHandler: EventHandler?
    private var appWasLaunchedManually: Bool = false
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Load config from disk
        let config = Configuration.fromDisk
        
        let eventHandler = EventHandler(appDelegate: self, config: config)
        self.eventHandler = eventHandler
        
        self.setEventHandler(#selector(eventHandler.handleAppOpen),     eventClass: kCoreEventClass, eventID: kAEOpenApplication)
        self.setEventHandler(#selector(eventHandler.handleGetURLEvent), eventClass: AEEventClass(kInternetEventClass), eventID: AEEventID(kAEGetURL))
        self.setEventHandler(#selector(eventHandler.handleFileOpen),    eventClass: kCoreEventClass, eventID: kAEOpenDocuments)
    }
    
    func setEventHandler(_ selector: Selector, eventClass: AEEventClass, eventID: AEEventID) {
        guard let eventHandler = self.eventHandler else { fatalError() }
        let eventManager = NSAppleEventManager.shared()
        eventManager.setEventHandler(eventHandler, andSelector: selector, forEventClass: eventClass, andEventID: eventID)
    }

    /// Handles manual app launches
    func handleAppOpen() {
        self.appWasLaunchedManually = true
        self.showWindow()
        
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

    /// Makes the window visible
    internal func showWindow() {
        self.window.setIsVisible(true)
        
        if #available(OSX 10.10, *) {
            self.removeTitleBar()
        }
        if #available(OSX 10.11, *) {
            self.addTransparency()
        }
    }
    
    /// Registers the app as default handler for http: and https: url schemes
    internal func registerDefaultBrowser() {
        guard let bundleID = Bundle.main.bundleIdentifier else { assertionFailure(); return }
        
        LSSetDefaultHandlerForURLScheme("http"  as CFString, bundleID as CFString)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleID as CFString)
    }
    
    /// Checks whether the app is registered as default handler for http: and https: url schemes
    internal func isDefaultBrowser() -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier else { assertionFailure(); return false }

        let defaultHTTPHandler  = LSCopyDefaultHandlerForURLScheme("http"  as CFString)?.takeRetainedValue()
        let defaultHTTPSHandler = LSCopyDefaultHandlerForURLScheme("https" as CFString)?.takeRetainedValue()

        let cfBundleID = bundleID as CFString
        return (defaultHTTPHandler == cfBundleID) && (defaultHTTPSHandler == cfBundleID)
    }
}


// MARK: - "Window controller"
extension AppDelegate {
    
    private func removeTitleBar() {
        guard let window = self.window else { return }
        
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
    }
    
    @available(OSX 10.11, *)
    private func addTransparency() {
        guard let contentView = self.window?.contentView else { return }
        
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .dark
        
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(visualEffect, positioned: .below, relativeTo: nil)
        visualEffect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        visualEffect.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
