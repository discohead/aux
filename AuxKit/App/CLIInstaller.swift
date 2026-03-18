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
        case userCancelled
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

    /// Checks if a symlink exists at `path` and points to `expectedTarget`.
    public static func isCorrectlyInstalled(at path: String = defaultInstallPath, expectedTarget: String? = nil) -> Bool {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else { return false }

        let target: String
        if let expected = expectedTarget {
            target = expected
        } else if let execPath = appExecutablePath() {
            target = execPath
        } else {
            return false
        }

        guard let destination = try? fileManager.destinationOfSymbolicLink(atPath: path) else {
            return false
        }

        return destination == target
    }

    /// Builds the shell command for creating the symlink with mkdir.
    public static func buildInstallShellCommand(executablePath: String, installPath: String) -> String {
        let parentDir = (installPath as NSString).deletingLastPathComponent
        return "mkdir -p '\(parentDir)' && ln -sf '\(executablePath)' '\(installPath)'"
    }

    /// Builds the shell command for removing the symlink.
    public static func buildUninstallShellCommand(installPath: String) -> String {
        return "rm -f '\(installPath)'"
    }

    /// Wraps a shell command in osascript for privilege escalation.
    public static func buildOsascriptCommand(shellCommand: String) -> String {
        let escaped = shellCommand.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "osascript -e \"do shell script \\\"\(escaped)\\\" with administrator privileges\""
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

    /// Installs the CLI symlink using osascript privilege escalation.
    public static func installWithPrivileges(at installPath: String = defaultInstallPath) async throws {
        guard let execPath = appExecutablePath() else {
            throw InstallError.bundleNotFound
        }

        let shellCmd = buildInstallShellCommand(executablePath: execPath, installPath: installPath)
        let osascriptCmd = buildOsascriptCommand(shellCommand: shellCmd)
        try await runPrivilegedCommand(osascriptCmd)
    }

    /// Uninstalls the CLI symlink.
    public static func uninstall(at installPath: String = defaultInstallPath) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: installPath) {
            try fileManager.removeItem(atPath: installPath)
        }
    }

    /// Uninstalls the CLI symlink using osascript privilege escalation.
    public static func uninstallWithPrivileges(at installPath: String = defaultInstallPath) async throws {
        let shellCmd = buildUninstallShellCommand(installPath: installPath)
        let osascriptCmd = buildOsascriptCommand(shellCommand: shellCmd)
        try await runPrivilegedCommand(osascriptCmd)
    }

    // MARK: - Private

    private static func runPrivilegedCommand(_ command: String) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]

        let stderrPipe = Pipe()
        process.standardError = stderrPipe

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
            let stderrText = String(data: stderrData, encoding: .utf8) ?? ""

            if stderrText.contains("User canceled") || stderrText.contains("(-128)") {
                throw InstallError.userCancelled
            }
            throw InstallError.installFailed(stderrText)
        }
    }
}
