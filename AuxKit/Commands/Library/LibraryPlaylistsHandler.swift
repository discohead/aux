//
//  LibraryPlaylistsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for listing playlists in the user's library.
public struct LibraryPlaylistsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        offset: Int = 0,
        sort: String? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.library.getPlaylists(limit: limit, offset: offset, sort: sort)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
    }
}
