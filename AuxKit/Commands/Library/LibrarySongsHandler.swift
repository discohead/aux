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
        allPages: Bool = false,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let filters = LibrarySongFilters(title: title, artist: artist, album: album, downloadedOnly: downloadedOnly)
        let outputWriter = writer ?? options.makeOutputWriter()

        if allPages {
            let allResults = try await PaginationHelper.fetchAll(pageSize: limit) { pageLimit, pageOffset in
                try await services.library.getSongs(limit: pageLimit, offset: pageOffset, sort: sort, filters: filters)
            }
            try outputWriter.write(OutputEnvelope(data: allResults, meta: PaginationMeta(limit: allResults.count, offset: 0, total: allResults.count, hasNext: false)))
        } else {
            let results = try await services.library.getSongs(limit: limit, offset: offset, sort: sort, filters: filters)
            try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
        }
    }
}
