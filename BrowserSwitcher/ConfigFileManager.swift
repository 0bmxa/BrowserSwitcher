//
//  ConfigFileManager.swift
//  BrowserSwitcher
//
//  Created by mayxe on 05.07.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import Foundation

internal class ConfigFileManager {
    internal let userURL: URL
    private let defaultURL: URL
    private var cachedConfig: Configuration?

    private var userConfigFileExists: Bool {
        let path = self.userURL.path
        return FileManager.default.fileExists(atPath: path)
    }

    init() {
        self.userURL = FileManager.default.urlInUserAppSupportDir(path: "BrowserSwitcher/Configuration.plist")
        //swiftlint:disable:next force_unwrapping
        self.defaultURL = Bundle.main.url(forResource: "DefaultConfiguration", withExtension: "plist")!
    }

    /// Reads a configuration from disk. First attempts to read the user config
    /// file; in case this fails reads the default config file.
    func read() -> Configuration {
        if let cachedConfig = self.cachedConfig {
            return cachedConfig
        }

        if self.userConfigFileExists {
            do {
                let data = try Data(contentsOf: self.userURL)
                let config: Configuration = try self.decode(from: data)
                self.cachedConfig = config
                return config
            } catch {
                Log.error("User config file is corrupt.", userURL)
                assertionFailure()
            }
        }

        Log.info("Cannot read user config file at:", userURL)

        do {
            let data = try Data(contentsOf: self.defaultURL)
            let config: Configuration = try self.decode(from: data)
            self.cachedConfig = config
            return config
        } catch {
            Log.error("Cannot read default config file at:", userURL)
            assertionFailure()
            return Configuration.generic
        }
    }

    /// Writes the specified configuration as a PropertyList file to the user
    /// config file location onto disk.
    /// - Parameters:
    ///   - config: The config to be written
    ///   - overwrite: Whether the file should be overwritten, in case it exists.
    func write(config: Configuration, overwrite: Bool = true) -> Bool {
        guard overwrite || !self.userConfigFileExists else {
            return true
        }

        do {
            let data = try self.encode(value: config)
            try data.write(to: self.userURL, options: .atomicWrite)

            self.cachedConfig = nil
            return true
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
    }

    private func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = PropertyListDecoder()
        return try decoder.decode(T.self, from: data)
    }

    private func encode<T: Encodable>(value: T) throws -> Data {
        let encoder = PropertyListEncoder()
        return try encoder.encode(value)
    }
}
