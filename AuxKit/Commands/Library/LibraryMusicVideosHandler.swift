//
//  LibraryMusicVideosHandler.swift
//  AuxKit
//

import Foundation

/// Handler for listing music videos in the user's library.
public struct LibraryMusicVideosHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        offset: Int = 0,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.library.getMusicVideos(limit: limit, offset: offset)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
    }
}
