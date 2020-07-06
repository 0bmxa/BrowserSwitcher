//
//  Log.swift
//  BrowserSwitcher
//
//  Created by mayxe on 28.06.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Foundation

//swiftlint:disable line_length

internal enum Log {
    enum Level: String {
        case error = "ERROR"
        case warn  = "WARN"
        case info  = "INFO"
        case debug = "DEBUG"
    }

    struct Trail {
        let message: String
        let level: Level
        let timestamp = Date()
    }

    private static var trail: [Trail] = []

    internal static func error(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, logFunction: #function)
    }

    internal static func warn(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, logFunction: #function)
    }

    internal static func info(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, logFunction: #function)
    }

    internal static func debug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, logFunction: #function)
    }


    private static func log(_ items: [Any], file: String, function: String, line: Int, logFunction: String) {
        let logFunctionName = String(logFunction.split(separator: "(")[0])
        let level = Level(rawValue: logFunctionName.uppercased()) ?? .info

        self.print(items, file: file, function: function, line: line, level: level)

        let message = items.reduce(into: "") { $0 += " " + String(describing: $1) }
        Log.trail.append(Trail(message: message, level: level))
    }

    private static func print(
        _ items: [Any],
        file: String,
        function: String,
        line: Int,
        level: Level
    ) {
        let separator: String = " "
        let terminator: String = "\n"

        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(")[0]
        let prefix = "\(fileName)/\(functionName):\(line): [\(level.rawValue)]"
        let message = items.reduce(prefix) { $0 + separator + String(describing: $1) }

        #if DEBUG
        Swift.print(message, terminator: terminator)
        #endif
    }
}

@available(*, unavailable)
internal func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {}
