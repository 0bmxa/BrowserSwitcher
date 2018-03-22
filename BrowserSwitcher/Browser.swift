//
//  Browser.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

//import Foundation

enum Browser {
    case chrome
    case safari
    case other(bundleIdentifier: String)
    
    var bundleIdentifier: String {
        switch self {
        case .chrome: return "com.google.Chrome"
        case .safari: return "com.apple.Safari"
        case .other(let bundleIdentifier): return bundleIdentifier
        }
    }
    
    init(bundleIdentifier: String) {
        switch bundleIdentifier {
        case "com.google.Chrome": self = .chrome
        case "com.apple.Safari":  self = .safari
        default:                  self = .other(bundleIdentifier: bundleIdentifier)
        }
    }
}

extension Browser: Hashable {
    var hashValue: Int {
        return self.bundleIdentifier.hashValue
    }
    
    static func ==(lhs: Browser, rhs: Browser) -> Bool {
        return lhs.hashValue  == rhs.hashValue
    }
}
