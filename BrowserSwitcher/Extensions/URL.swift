//
//  URL.swift
//  BrowserSwitcher
//
//  Created by mayxe on 15.08.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Foundation

extension URL {
    /// Applies an Exception.Transformation to an URL.
    /// - Parameter transformation: The transformation to apply.
    func transformed(by transformation: Exception.Transformation) -> URL {
        let search = transformation.search
        let replace = transformation.replace
        
        let string = self.absoluteString
        let transformedString = string.replacingOccurrences(of: search, with: replace)
        
        guard let transformed = URL(string: transformedString) else { return self }
        return transformed
    }
}
