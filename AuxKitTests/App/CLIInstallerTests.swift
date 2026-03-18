//
//  CLIInstallerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct CLIInstallerTests {
    @Test func defaultInstallPathIsUsrLocalBin() {
        #expect(CLIInstaller.defaultInstallPath == "/usr/local/bin/aux")
    }

    @Test func isInstalledReturnsFalseForNonexistentPath() {
        let result = CLIInstaller.isInstalled(at: "/tmp/aux-test-nonexistent-\(UUID().uuidString)")
        #expect(!result)
    }

    @Test func installAndUninstallRoundTrip() throws {
        let tempDir = FileManager.default.temporaryDirectory.path
        let testPath = "\(tempDir)/aux-test-\(UUID().uuidString)"

        // Create a dummy file to symlink to
        let dummyPath = "\(tempDir)/aux-dummy-\(UUID().uuidString)"
        FileManager.default.createFile(atPath: dummyPath, contents: nil)
        defer {
            try? FileManager.default.removeItem(atPath: testPath)
            try? FileManager.default.removeItem(atPath: dummyPath)
        }

        // Can't test install() directly since it uses Bundle.main.executablePath
        // which is nil in test context. Test the uninstall path instead.
        FileManager.default.createFile(atPath: testPath, contents: nil)
        #expect(CLIInstaller.isInstalled(at: testPath))

        try CLIInstaller.uninstall(at: testPath)
        #expect(!CLIInstaller.isInstalled(at: testPath))
    }

    // MARK: - isCorrectlyInstalled tests

    @Test func isCorrectlyInstalledReturnsFalseForNonexistentPath() {
        let result = CLIInstaller.isCorrectlyInstalled(
            at: "/tmp/aux-test-nonexistent-\(UUID().uuidString)",
            expectedTarget: "/some/target"
        )
        #expect(!result)
    }

    @Test func isCorrectlyInstalledReturnsFalseForRegularFile() throws {
        let tempDir = FileManager.default.temporaryDirectory.path
        let testPath = "\(tempDir)/aux-test-\(UUID().uuidString)"
        FileManager.default.createFile(atPath: testPath, contents: nil)
        defer { try? FileManager.default.removeItem(atPath: testPath) }

        let result = CLIInstaller.isCorrectlyInstalled(at: testPath, expectedTarget: "/some/target")
        #expect(!result)
    }

    @Test func isCorrectlyInstalledReturnsTrueForCorrectSymlink() throws {
        let tempDir = FileManager.default.temporaryDirectory.path
        let targetPath = "\(tempDir)/aux-target-\(UUID().uuidString)"
        let linkPath = "\(tempDir)/aux-link-\(UUID().uuidString)"
        FileManager.default.createFile(atPath: targetPath, contents: nil)
        defer {
            try? FileManager.default.removeItem(atPath: linkPath)
            try? FileManager.default.removeItem(atPath: targetPath)
        }

        try FileManager.default.createSymbolicLink(atPath: linkPath, withDestinationPath: targetPath)

        let result = CLIInstaller.isCorrectlyInstalled(at: linkPath, expectedTarget: targetPath)
        #expect(result)
    }

    @Test func isCorrectlyInstalledReturnsFalseForWrongTarget() throws {
        let tempDir = FileManager.default.temporaryDirectory.path
        let targetPath = "\(tempDir)/aux-target-\(UUID().uuidString)"
        let wrongTarget = "\(tempDir)/aux-wrong-\(UUID().uuidString)"
        let linkPath = "\(tempDir)/aux-link-\(UUID().uuidString)"
        FileManager.default.createFile(atPath: targetPath, contents: nil)
        defer {
            try? FileManager.default.removeItem(atPath: linkPath)
            try? FileManager.default.removeItem(atPath: targetPath)
        }

        try FileManager.default.createSymbolicLink(atPath: linkPath, withDestinationPath: targetPath)

        let result = CLIInstaller.isCorrectlyInstalled(at: linkPath, expectedTarget: wrongTarget)
        #expect(!result)
    }

    // MARK: - Privileged command building tests

    @Test func installCommandBuildsCorrectShellCommand() {
        let cmd = CLIInstaller.buildInstallShellCommand(
            executablePath: "/Applications/aux.app/Contents/MacOS/aux",
            installPath: "/usr/local/bin/aux"
        )
        #expect(cmd.contains("mkdir -p"))
        #expect(cmd.contains("/usr/local/bin"))
        #expect(cmd.contains("ln -sf"))
        #expect(cmd.contains("/Applications/aux.app/Contents/MacOS/aux"))
        #expect(cmd.contains("/usr/local/bin/aux"))
    }

    @Test func uninstallCommandBuildsCorrectShellCommand() {
        let cmd = CLIInstaller.buildUninstallShellCommand(installPath: "/usr/local/bin/aux")
        #expect(cmd.contains("rm -f"))
        #expect(cmd.contains("/usr/local/bin/aux"))
    }

    @Test func osascriptCommandWrapsShellCommandCorrectly() {
        let shellCmd = "mkdir -p /usr/local/bin && ln -sf '/target' '/source'"
        let osascript = CLIInstaller.buildOsascriptCommand(shellCommand: shellCmd)
        #expect(osascript.contains("osascript"))
        #expect(osascript.contains("do shell script"))
        #expect(osascript.contains("with administrator privileges"))
    }

    // MARK: - Error cases

    @Test func installErrorUserCancelledExists() {
        let error: Error = CLIInstaller.InstallError.userCancelled
        #expect(error is CLIInstaller.InstallError)
    }
}
