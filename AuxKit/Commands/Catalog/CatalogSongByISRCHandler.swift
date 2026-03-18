//
//  CatalogSongByISRCHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting songs from the Apple Music catalog by ISRC.
/// Accepts a single ISRC or comma-separated ISRCs for batch lookup.
public struct CatalogSongByISRCHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        isrc: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let isrcs = isrc.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        var allSongs: [SongDTO] = []
        for code in isrcs {
            let result = try await services.catalog.getSongByISRC(isrc: code)
            allSongs.append(contentsOf: result)
        }
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: allSongs))
    }
}
