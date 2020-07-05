//
//  NSAppleEventDescriptor.swift
//  BrowserSwitcher
//
//  Created by mayxe on 17.06.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Cocoa
import Foundation

extension NSAppleEventDescriptor {
    /// Get URL from event, if available
    var url: URL? {
        guard
            let directObject = self.paramDescriptor(forKeyword: keyDirectObject),
            let urlString = directObject.stringValue
            else { return nil }
        return URL(string: urlString)
    }
}

internal let kAEInternetEventClass = AEEventClass(kInternetEventClass)
internal let kAEGetURLEventID = AEEventID(kAEGetURL)
