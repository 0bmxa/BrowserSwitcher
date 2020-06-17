//
//  NSView.swift
//  BrowserSwitcher
//
//  Created by mayxe on 17.06.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import AppKit

@available(OSX 10.11, *)
extension NSView {
    func setAnchors(equalTo parentView: NSView) {
        guard parentView.subviews.contains(self) else { assertionFailure(); return }
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
