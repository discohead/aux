//
//  APIGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `api get` command — makes a raw GET request to the Apple Music API.
public struct APIGetHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        path: String,
        queryParams: [String: String]? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let data = try await services.restAPI.get(path: path, queryParams: queryParams)
        let result = RawAPIResponse(data: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
