//
//  LibraryAddHandler.swift
//  AuxKit
//

import Foundation

/// Handler for adding catalog items to the user's library via REST API.
public struct LibraryAddHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        ids: [String],
        type: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let body: [String: Any] = [
            "ids": ids,
            "type": type
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        _ = try await services.restAPI.post(path: "/v1/me/library", body: bodyData)
        let result = AddToLibraryResult(added: true, ids: ids, type: type)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
