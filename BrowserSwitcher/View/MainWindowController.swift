//
//  MainWindowController.swift
//  BrowserSwitcher
//
//  Created by mayxe on 02.08.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Cocoa

@objc
internal class MainWindowController: NSObject {
    internal weak var configFileManager: ConfigFileManager?
    private var tableViewController: TableViewController?
    private var isSetup: Bool = false

    @IBOutlet private var window: NSWindow!
    @IBOutlet private var tableView: NSTableView!
    @IBOutlet private var defaultBrowserTextField: ImageTextField!

    /// Inits and sets up everything, but only when needed
    private func setup() {
        guard !self.isSetup else { return }

        self.tableViewController = TableViewController(tableView: self.tableView)
        self.isSetup = true
    }

    /// Makes the window visible
    internal func showWindow() {
        self.setup()
        self.window?.setIsVisible(true)
        self.window.center()

        if #available(OSX 10.11, *) {
            self.addTransparency()
        }

        self.update()
    }

    internal func update() {
        guard let config = self.configFileManager?.read() else { return }
        self.tableViewController?.show(config: config)

        self.defaultBrowserTextField.stringValue = config.defaultBrowserBundleID
        self.defaultBrowserTextField.image = NSWorkspace.shared.appIcon(for: config.defaultBrowserBundleID)
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
        visualEffect.setAnchors(equalTo: contentView)
    }
}

internal class ImageTextField: NSTextField {
    private let imageView = NSImageView()

    var image: NSImage? {
        get {
            self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()

//        self.addSubview(self.imageView, positioned: .above, relativeTo: self)
//
//        self.addConstraint(equalsTo: self.imageView, attribute: .leading)
//        self.addConstraint(equalsTo: self.imageView, attribute: .centerY)
//        self.addConstraint(equalsTo: self.imageView, attribute: .height)
//        self.imageView.addConstraint(attribute: .height, equals: .width)
    }
}
