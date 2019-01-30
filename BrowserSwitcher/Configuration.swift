//
//  Configuration.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Foundation

struct Configuration {
    /// The browser to be opened for all non-exception URLs.
    let defaultBrowser: Browser
    
    /// A list containing exceptions for the default browser.
    let exceptions: [ExceptionHost]

    /// Storage changeable for testing
    private var storage = UserDefaults.standard

    /// Storage keys (for User Defaults)
    private let kDefaultBrowserStorageKey = "defaultBrowser"
    private let kExceptionHostsStorageKey = "exceptions"
    
    init(defaultBrowser: Browser, exceptions: [ExceptionHost]) {
        self.defaultBrowser = defaultBrowser
        self.exceptions = exceptions
    }

    init(fromDisk: Bool = true) {
        var defaultBrowser: Browser = .firefox
        var exceptionHosts: [ExceptionHost] = []
        
        if fromDisk {
            if let defaultBrowserBundleID = self.storage.string(forKey: kDefaultBrowserStorageKey) {
                defaultBrowser = Browser(bundleIdentifier: defaultBrowserBundleID)
            }
            if let exceptions = self.storage.array(forKey: kExceptionHostsStorageKey) as? [ExceptionHost] {
                exceptionHosts = exceptions
            }
        }

        self.defaultBrowser = defaultBrowser
        self.exceptions = exceptionHosts
    }
}


// MARK: - Storage on disk
extension Configuration {
    /// Writes the Configuration object to disk
    func writeToDisk() {
        self.storage.set(self.defaultBrowser.bundleIdentifier, forKey: kDefaultBrowserStorageKey)
        self.storage.set(self.exceptions, forKey: kExceptionHostsStorageKey)
    }
    
    /// Creates a new Configuration object based on the one stored on disk
    static var fromDisk: Configuration {
        return Configuration(fromDisk: true)
    }
}
