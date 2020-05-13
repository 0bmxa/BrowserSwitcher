//
//  Browser.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

struct Browser {
    let bundleIdentifier: String
    //let name: String
}

extension Browser: Hashable {
    var hashValue: Int {
        return self.bundleIdentifier.hashValue
    }
    
    static func ==(lhs: Browser, rhs: Browser) -> Bool {
        return lhs.hashValue  == rhs.hashValue
    }
}


// MARK: - Some common preconfigured browsers
extension Browser {
    static var chrome: Browser  = Browser(bundleIdentifier: "com.google.Chrome")
    static var firefox: Browser = Browser(bundleIdentifier: "org.mozilla.firefox")
    static var safari: Browser  = Browser(bundleIdentifier: "com.apple.Safari")
}
