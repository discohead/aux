//
//  CatalogAlbumByUPCHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting albums from the Apple Music catalog by UPC.
public struct CatalogAlbumByUPCHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        upc: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getAlbumByUPC(upc: upc)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
