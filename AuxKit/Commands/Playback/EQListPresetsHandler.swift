//
//  EQListPresetsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Result type for EQ presets list.
public struct EQPresetsResult: Codable, Equatable, Sendable {
    public let presets: [String]

    public init(presets: [String]) {
        self.presets = presets
    }
}

/// Handler for the `playback eq-list` command — lists available EQ presets.
public struct EQListPresetsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.listEQPresets()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: EQPresetsResult(presets: result)))
    }
}
