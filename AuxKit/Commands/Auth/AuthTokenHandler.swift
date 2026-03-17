//
//  AuthTokenHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `auth token` command — retrieves developer or user tokens.
public struct AuthTokenHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.auth.getToken(type: type)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
