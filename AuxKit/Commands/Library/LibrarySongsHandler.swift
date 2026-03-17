//
//  LibrarySongsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for listing songs in the user's library.
public struct LibrarySongsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        offset: Int = 0,
        sort: String? = nil,
        title: String? = nil,
        artist: String? = nil,
        album: String? = nil,
        downloadedOnly: Bool = false,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let filters = LibrarySongFilters(title: title, artist: artist, album: album, downloadedOnly: downloadedOnly)
        let results = try await services.library.getSongs(limit: limit, offset: offset, sort: sort, filters: filters)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
    }
}
