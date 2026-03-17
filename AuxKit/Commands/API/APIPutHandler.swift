//
//  APIPutHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `api put` command — makes a raw PUT request to the Apple Music API.
public struct APIPutHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        path: String,
        body: String? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let bodyData = body.flatMap { $0.data(using: .utf8) }
        let data = try await services.restAPI.put(path: path, body: bodyData)
        let result = RawAPIResponse(data: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
