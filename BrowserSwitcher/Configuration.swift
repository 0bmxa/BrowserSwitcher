//
//  Configuration.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Foundation

internal struct Configuration: Codable {
    /// The bundle ID for the default browser.
    let defaultBrowserBundleID: String
    /// An array of exceptions to the default opening behavior.
    let exceptions: [Exception]

    /// Creates a new configuration.
    /// - Parameters:
    ///   - defaultBrowserBundleID: The bundle ID for the default browser.
    ///   - exceptions: An array of exceptions to the default opening behavior.
    init(defaultBrowserBundleID: String, exceptions: [Exception]) {
        self.defaultBrowserBundleID = defaultBrowserBundleID
        self.exceptions = exceptions
    }
}
