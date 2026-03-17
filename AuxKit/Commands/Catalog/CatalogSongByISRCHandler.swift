//
//  CatalogSongByISRCHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting songs from the Apple Music catalog by ISRC.
public struct CatalogSongByISRCHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        isrc: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getSongByISRC(isrc: isrc)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
