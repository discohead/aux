//
//  LibraryAlbumsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for listing albums in the user's library.
public struct LibraryAlbumsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        offset: Int = 0,
        sort: String? = nil,
        title: String? = nil,
        artist: String? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let filters = LibraryAlbumFilters(title: title, artist: artist)
        let results = try await services.library.getAlbums(limit: limit, offset: offset, sort: sort, filters: filters)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
    }
}
