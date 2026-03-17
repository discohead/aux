//
//  EQGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Result type for the current EQ preset query.
public struct EQCurrentResult: Codable, Equatable, Sendable {
    public let enabled: Bool
    public let preset: String?

    public init(enabled: Bool, preset: String?) {
        self.enabled = enabled
        self.preset = preset
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enabled, forKey: .enabled)
        // Always encode preset, even if nil (explicit null in JSON)
        try container.encode(preset, forKey: .preset)
    }

    enum CodingKeys: String, CodingKey {
        case enabled, preset
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
        let enabled = result != nil
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: EQCurrentResult(enabled: enabled, preset: result)))
    }
}
