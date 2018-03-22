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
}


// MARK: - Storage on disk
extension Configuration {
    /// Writes the Configuration object to disk
    func writeToDisk() {
        UserDefaults.standard.set(self.defaultBrowser, forKey: "defaultBrowser")
        UserDefaults.standard.set(self.exceptions, forKey: "exceptions")
    }
    
    /// Creates a new Configuration object based on the one stored on disk
    static var fromDisk: Configuration {
        let defaultBrowser: Browser = UserDefaults.standard.object(forKey: "defaultBrowser") as? Browser ?? .safari
        let exceptions = UserDefaults.standard.object(forKey: "exceptions") as? [ExceptionHost] ?? [ExceptionHost]()
        
        return Configuration(defaultBrowser: defaultBrowser, exceptions: exceptions)
    }
}
