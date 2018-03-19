//
//  Configuration.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

struct Configuration {
    /// The browser to be opened for all non-exception URLs.
    let defaultBrowser: Browser
    
    /// The browser to be opened for all exception URLs.
    let alternativeBrowser: Browser
    
    /// A list of URLs (hostname only) to be opened on the alternative browser.
    let exceptionURLs: [String]
}
