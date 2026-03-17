//
//  APIPostHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `api post` command — makes a raw POST request to the Apple Music API.
public struct APIPostHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        path: String,
        body: String? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let bodyData = body.flatMap { $0.data(using: .utf8) }
        let data = try await services.restAPI.post(path: path, body: bodyData)
        let result = RawAPIResponse(data: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
