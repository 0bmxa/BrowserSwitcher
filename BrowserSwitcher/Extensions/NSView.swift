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

//swiftlint:disable multiline_arguments
extension NSView {
    typealias LayoutAttribute = NSLayoutConstraint.Attribute

    func addConstraint(equalsTo item: NSView, attribute: LayoutAttribute) {
        let constraint = NSLayoutConstraint(
            item: self, attribute: attribute,
            equals: item, attribute: attribute
        )
        self.addConstraint(constraint)
    }

    func addConstraint(attribute attribute1: LayoutAttribute, equals attribute2: LayoutAttribute) {
        let constraint = NSLayoutConstraint(
            item: self, attribute: attribute1,
            equals: self, attribute: attribute2
        )
        self.addConstraint(constraint)
    }
}

extension NSLayoutConstraint {
    convenience init(
        item view1: NSView,
        attribute attribute1: Attribute,
        equals view2: NSView,
        attribute attribute2: Attribute
    ) {
        self.init(
            item: view1, attribute: attribute1,
            relatedBy: .equal,
            toItem: view2, attribute: attribute2,
            multiplier: 1.0, constant: 0.0
        )
    }
}
