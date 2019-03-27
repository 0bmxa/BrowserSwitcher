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
    @IBOutlet private weak var window: NSWindow!
    
    private var eventHandler: EventHandler?
    private var appWasLaunchedManually: Bool = false
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let eventHandler = EventHandler(appDelegate: self)
        self.eventHandler = eventHandler
        
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleAppOpen), forEventClass: kCoreEventClass, andEventID: kAEOpenApplication)
        NSAppleEventManager.shared().setEventHandler(eventHandler, andSelector: #selector(EventHandler.handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        NSAppleEventManager.shared().setEventHandler(eventHandler, andSelector: #selector(EventHandler.handleFileOpen), forEventClass: kCoreEventClass, andEventID: kAEOpenDocuments)
    }
    
    /// Handles manual app launches
    @objc func handleAppOpen(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        self.appWasLaunchedManually = true
        self.window.setIsVisible(true)
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
    }
}
