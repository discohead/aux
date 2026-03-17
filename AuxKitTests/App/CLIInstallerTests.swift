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
}
