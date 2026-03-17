//
//  CLIInstaller.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Manages symlink installation for CLI access.
public struct CLIInstaller {
    public enum InstallError: Error, Sendable {
        case bundleNotFound
        case installFailed(String)
    }

    /// The default install path for the CLI symlink.
    public static let defaultInstallPath = "/usr/local/bin/aux"

    /// Returns the path to the app's own executable (dual-mode binary).
    public static func appExecutablePath() -> String? {
        return Bundle.main.executablePath
    }

    /// Checks if the CLI symlink is already installed at the given path.
    public static func isInstalled(at path: String = defaultInstallPath) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    /// Installs a symlink from `installPath` to the app's executable.
    public static func install(at installPath: String = defaultInstallPath) throws {
        guard let execPath = appExecutablePath() else {
            throw InstallError.bundleNotFound
        }

        let fileManager = FileManager.default

        // Remove existing symlink if present
        if fileManager.fileExists(atPath: installPath) {
            try fileManager.removeItem(atPath: installPath)
        }

        // Create parent directory if needed
        let parentDir = (installPath as NSString).deletingLastPathComponent
        if !fileManager.fileExists(atPath: parentDir) {
            try fileManager.createDirectory(atPath: parentDir, withIntermediateDirectories: true)
        }

        try fileManager.createSymbolicLink(atPath: installPath, withDestinationPath: execPath)
    }

    /// Uninstalls the CLI symlink.
    public static func uninstall(at installPath: String = defaultInstallPath) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: installPath) {
            try fileManager.removeItem(atPath: installPath)
        }
    }
}
