//
//  EQGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Result type for the current EQ preset query.
public struct EQCurrentResult: Codable, Equatable, Sendable {
    public let preset: String?

    public init(preset: String?) {
        self.preset = preset
    }
}

/// Handler for the `playback eq-get` command — gets the current EQ preset.
public struct EQGetHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getEQ()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: EQCurrentResult(preset: result)))
    }
}
