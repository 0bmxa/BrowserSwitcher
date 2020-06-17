//
//  Exception.swift
//  BrowserSwitcher
//
//  Created by 0bmxa on 13.06.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Foundation

/// A data structure describing when an exception to the default URL-open
/// bahavior should be made.
/// (Default behavior: default browser opens the URL as-is.)
internal struct Exception: Codable {
    /// A simple search-replace URL transformation.
    struct Transformation: Codable {
        let search: String
        let replace: String
    }

    /// The hostname in the URL for which the exception applies.
    let host: String

    /// The bundle ID of the browser to be used for this exception.
    let browserBundleID: String?

    /// An optional search-replace transformation to be applied to the URL.
    let transformation: Transformation?
}

extension Exception {
    func matches(host: String) -> Bool {
        // If no wildcard character exists, do direct comparison
        guard self.host.contains("*") else {
            return self.host == host
        }

        // Split both hostnames into domain components
        // Note: Should also work for IPv4 addresses, but not IPv6 :(
        let referenceHostParts = self.host.components(separatedBy: ".")
        let inputHostParts = host.components(separatedBy: ".")

        // Make sure the incoming host is at least as long as our wildcard url,
        // otherwise its no match
        guard inputHostParts.count >= referenceHostParts.count else { return false }

        var hostsMatch = true

        // Iterate over the reference list (of host parts) in reverse order and
        // compare whether they are similar or the "wildcard" operator
        let reversedReferenceHostParts: [String] = referenceHostParts.reversed()
        let reversedInputHostParts: [String] = inputHostParts.reversed()
        reversedReferenceHostParts.enumerated().forEach { (offset: Int, element: String) in
            let inputElement = reversedInputHostParts[offset]
            if element != "*" && element != inputElement {
                hostsMatch = false
                return
            }
        }

        return hostsMatch
    }

    func applyTransformation(to url: URL) -> URL {
        guard
            let search = self.transformation?.search,
            let replace = self.transformation?.replace
        else { return url }

        let urlString = url.absoluteString
        let transformedURLString = urlString.replacingOccurrences(of: search, with: replace)

        guard let transformedURL = URL(string: transformedURLString) else { return url }
        return transformedURL
    }
}
