//
//  ExceptionHost.swift
//  BrowserSwitcher
//
//  Created by mxa on 21.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

/// Describes a host for which an exception to the default browser should be made.
struct ExceptionHost {
    /// A convenience type for describing a simple search-replace
    /// URL transformation.
    typealias TransformationDescription = (search: String, replace: String)

    /// The hostname in the URL for which the exception applies.
    let host: String
    
    /// The browser to be used for this exception.
    let browser: Browser?
    
    /// Optional: A search-replace transformation to be applied to the URL.
    let transformation: TransformationDescription?
    
    init(host: String, browser: Browser) {
        self.host = host
        self.browser = browser
        self.transformation = nil
    }

    init(host: String, transformation: TransformationDescription) {
        self.host = host
        self.browser = nil
        self.transformation = transformation
    }

    init(host: String, browser: Browser, transformation: TransformationDescription) {
        self.host = host
        self.browser = browser
        self.transformation = transformation
    }
}

extension ExceptionHost {
    func hostEquals(_ inputHost: String) -> Bool {
        // If no wildcard character exists, do direct comparison
        guard self.host.contains("*") else {
            return self.host == inputHost
        }
        
        // Split both hostnames into domain components
        // Note: Should also work for IPv4 addresses, but not IPv6 :(
        let referenceHostParts = self.host.components(separatedBy: ".")
        let inputHostParts = inputHost.components(separatedBy: ".")
        
        // Make sure the incoming host is at least as long as our wildcard url, otherwise its no match
        guard inputHostParts.count >= referenceHostParts.count else { return false }

        var hostsMatch = true
        
        // Iterate over the reference list (of host parts) in reverse order and compare
        // whether they are similar or the "wildcard" operator
        referenceHostParts.enumerated().reversed().forEach { (offset: Int, element: String) in
            let inputElement = inputHostParts[offset]
            if element != "*" && element != inputElement {
                hostsMatch = false
                return
            }
        }
        
        return hostsMatch
    }
}

extension ExceptionHost: Hashable {
    var hashValue: Int {
        return self.host.hashValue
    }
    
    static func ==(lhs: ExceptionHost, rhs: ExceptionHost) -> Bool {
        return lhs.hashValue  == rhs.hashValue
    }
}

