//
//  Configuration.swift
//  BrowserPicker
//
//  Created by mxa on 19.03.2018.
//  Copyright © 2018 0bmxa. All rights reserved.
//

import Foundation

struct Configuration: Codable {
    /// The bundle ID for the default browser.
    let defaultBrowserBundleID: String
    /// An array of exceptions to the default opening behavior.
    let exceptions: [Exception]

    /// Creates a new configuration.
    /// - Parameters:
    ///   - defaultBrowserBundleID: The bundle ID for the default browser.
    ///   - exceptions: An array of exceptions to the default opening behavior.
    init(defaultBrowserBundleID: String, exceptions: [Exception]) {
        self.defaultBrowserBundleID = defaultBrowserBundleID
        self.exceptions = exceptions
    }

    /// Reads an existing configuration from a PropertyList file.
    /// - Parameter fileURL: A file URL to the PList on disk.
    init(from fileURL: URL) throws {
        let decoder = PropertyListDecoder()

        let data = try Data.init(contentsOf: fileURL)
        self = try decoder.decode(Configuration.self, from: data)
    }

    /// Writes the current configuration as a PropertyList to disk.
    /// - Parameter fileURL: A file URL to the PList on disk.
    func write(to fileURL: URL) throws {
        let encoder = PropertyListEncoder()

        let data = try encoder.encode(self)
        try data.write(to: fileURL, options: .atomicWrite)
    }
}

// MARK: - Storage on disk
extension Configuration {
    static var fromDisk: Configuration {
        let appSupportDirectoryFileURL = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        let userConfigFileURL = appSupportDirectoryFileURL?
            .appendingPathComponent("BrowserSwitcher/Configuration.plist")

        if let userConfigFileURL = userConfigFileURL,
            FileManager.default.fileExists(atPath: userConfigFileURL.path) {
            do {
                return try Configuration(from: userConfigFileURL)
            } catch {
                print("[ERROR] User config file is corrupt.", userConfigFileURL.path)
                assertionFailure()
            }
        }

        print("[INFO] Cannot read user config file at:", userConfigFileURL?.path ?? "?")

        let defaultConfigFileURL = Bundle.main.url(forResource: "DefaultConfiguration", withExtension: "plist")!
        do {
            return try self.init(from: defaultConfigFileURL)
        } catch {
            return Configuration(defaultBrowserBundleID: "com.apple.Safari", exceptions: [])
        }
    }

    func writeToDisk() {
        do {
            let applicationSupportDirURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )

            let appDirURL = applicationSupportDirURL.appendingPathComponent("BrowserSwitcher")
            try FileManager.default.createDirectory(at: appDirURL, withIntermediateDirectories: true, attributes: nil)

            let configFileURL = appDirURL.appendingPathComponent("Configuration.plist")
            try self.write(to: configFileURL)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
