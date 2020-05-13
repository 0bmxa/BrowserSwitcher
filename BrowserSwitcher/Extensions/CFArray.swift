//
//  CFArray.swift
//  BrowserSwitcher
//
//  Created by mayxe on 13.05.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import CoreFoundation

extension CFArray {
    var count: Int {
        return CFArrayGetCount(self)
    }
    
    subscript(index: Int) -> UnsafeRawPointer? {
        guard index < self.count else { return nil }
        return CFArrayGetValueAtIndex(self, index)!
    }
    
    subscript<T>(index: Int) -> T? {
        return self[index]?.assumingMemoryBound(to: T.self).pointee
    }
    
    func contains<T: CFTypeRef>(_ search: T) -> Bool {
        for i in 0 ..< self.count {
            let item: T? = self[i]
            if CFEqual(item, search) {
                return true
            }
        }
        return false
    }
}
