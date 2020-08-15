//
//  NSWorkspace.swift
//  BrowserSwitcher
//
//  Created by mayxe on 02.08.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Cocoa

extension NSWorkspace {
    func appIcon(for bundleID: String) -> NSImage? {
        guard
            let appURL = self.urlForApplication(withBundleIdentifier: bundleID),
            let bundle = Bundle(url: appURL),
            let iconName = bundle.object(forInfoDictionaryKey: "CFBundleIconFile") as? String
        else { return nil }

        return bundle.image(forResource: iconName)
    }
}
