//
//  AirPlayCurrentHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Result type for the current AirPlay device query.
public struct AirPlayCurrentResult: Codable, Equatable, Sendable {
    public let device: String?

    public init(device: String?) {
        self.device = device
    }
}

/// Handler for the `playback airplay-current` command — gets the current AirPlay device.
public struct AirPlayCurrentHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getCurrentAirPlayDevice()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: AirPlayCurrentResult(device: result)))
    }
}
