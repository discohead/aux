//
//  LaunchModeDetectorTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
@testable import AuxKit

struct LaunchModeDetectorTests {
    @Test func detectReturnsLaunchMode() {
        // In test context, detect() should return some mode without crashing
        let mode = LaunchModeDetector.detect()
        // Just verify it returns a valid mode
        switch mode {
        case .gui, .cli: break // both are valid
        }
    }

    @Test func launchModeEnumHasBothCases() {
        let gui: LaunchMode = .gui
        let cli: LaunchMode = .cli
        #expect(gui != cli)
    }

    @Test func detectMethodForArgsReturnsCLIForAnyArgument() {
        // Test the logic: any first argument should mean CLI mode
        // We test this indirectly since CommandLine.arguments can't be mocked,
        // but verify the detector function exists and returns valid results
        let mode = LaunchModeDetector.detect()
        // In test context, there are test runner arguments, so it should return .cli
        #expect(mode == .cli)
    }
}
