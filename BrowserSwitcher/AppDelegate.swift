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
        self.showWindow()
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
}


// MARK: - "Window controller"
extension AppDelegate {
    
    @available(OSX 10.10, *)
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
