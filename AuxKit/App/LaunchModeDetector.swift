//
//  LaunchModeDetector.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Represents how the app was launched.
public enum LaunchMode: Sendable, Equatable {
    case gui
    case cli
}

/// Detects whether the app was launched as GUI or CLI.
public struct LaunchModeDetector {
    public static func detect() -> LaunchMode {
        // Check command line arguments first — most reliable signal
        let args = CommandLine.arguments
        if args.count > 1 {
            // Any argument at all means CLI mode — the user typed something after "aux"
            return .cli
        }

        // Check if launched as a symlink named "aux-cli" from terminal
        if ProcessInfo.processInfo.processName == "aux-cli" {
            return .cli
        }

        // Check if stdin is a TTY — indicates terminal launch
        // Note: __CFBundleIdentifier is always set for executables in .app bundles,
        // so we don't check it. Instead, check for NSApplication's launch context.
        if isatty(STDIN_FILENO) != 0 {
            // Running in a terminal. Check if launched via Finder/open command
            // by looking for the typical Finder launch indicator.
            let env = ProcessInfo.processInfo.environment
            if env["__CFBundleIdentifier"] != nil && env["XPC_SERVICE_NAME"] == nil {
                // Has bundle ID but no XPC service — likely double-clicked or `open` command.
                // Fall through to GUI.
            } else {
                return .cli
            }
        }

        return .gui
    }
}
