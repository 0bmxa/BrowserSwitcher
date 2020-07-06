//
//  FileManager.swift
//  BrowserSwitcher
//
//  Created by mayxe on 17.06.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Foundation

extension FileManager {
    func urlInUserAppSupportDir(path pathComponent: String) -> URL {
        let appSupportDirURL = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        //swiftlint:disable:next force_unwrapping
        return appSupportDirURL!.appendingPathComponent(pathComponent)
    }
}
