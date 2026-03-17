//
//  LibrarySearchHandler.swift
//  AuxKit
//

import Foundation

/// Handler for searching the user's library.
public struct LibrarySearchHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        query: String,
        types: [String] = [],
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.library.search(query: query, types: types, limit: limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
