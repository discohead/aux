//
//  CatalogRecordLabelHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting a record label from the Apple Music catalog by ID.
public struct CatalogRecordLabelHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        id: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getRecordLabel(id: id)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
