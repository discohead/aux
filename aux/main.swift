//
//  main.swift
//  aux
//
//  Created by Jared McFarland on 3/17/26.
//

import AppKit
import ArgumentParser
import Foundation
import SwiftUI
import AuxKit

/// Forces Swift to resolve the async overload of main() via generic constraint.
func runAsyncCommand<C: AsyncParsableCommand>(_: C.Type) async {
    await C.main()
}

let mode = LaunchModeDetector.detect()

if mode == .cli {
    // MusicKit requires a running NSApplication with its run loop to establish
    // XPC connections for developer token requests. Run headless (no dock icon).
    let app = NSApplication.shared
    app.setActivationPolicy(.prohibited)

    Task { @MainActor in
        await runAsyncCommand(AuxCommand.self)
        app.terminate(nil)
    }

    app.run()
} else {
    auxApp.main()
}
