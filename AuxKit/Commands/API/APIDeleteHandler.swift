//
//  APIDeleteHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `api delete` command — makes a raw DELETE request to the Apple Music API.
public struct APIDeleteHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        path: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let data = try await services.restAPI.delete(path: path)
        let result = RawAPIResponse(data: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
