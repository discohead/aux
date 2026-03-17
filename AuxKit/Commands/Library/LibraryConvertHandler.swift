//
//  LibraryConvertHandler.swift
//  AuxKit
//

import Foundation

/// Handler for converting tracks via AppleScript.
public struct LibraryConvertHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackIds: [Int],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.convertTracks(trackIds: trackIds)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}
