//
//  CaptureOutputWriterTests.swift
//  AuxKitTests
//
//  Created by Claude on 3/21/26.
//

import Testing
@testable import AuxKit

@Suite("CaptureOutputWriter Tests")
struct CaptureOutputWriterTests {

    @Test("captures OutputEnvelope as JSON string")
    func capturesEnvelopeJSON() throws {
        let writer = CaptureOutputWriter()
        let envelope = OutputEnvelope(data: ["status": "authorized"])
        try writer.write(envelope)

        let captured = try #require(writer.capturedString)
        #expect(captured.contains("\"data\""))
        #expect(captured.contains("authorized"))
    }

    @Test("captures CLIErrorResponse as JSON string")
    func capturesErrorJSON() throws {
        let writer = CaptureOutputWriter()
        let error = CLIErrorResponse(code: "test_error", message: "Something failed")
        try writer.writeError(error)

        let captured = try #require(writer.capturedString)
        #expect(captured.contains("\"error\""))
        #expect(captured.contains("test_error"))
    }

    @Test("returns nil before any write")
    func returnsNilBeforeWrite() {
        let writer = CaptureOutputWriter()
        #expect(writer.capturedString == nil)
    }

    @Test("last write wins")
    func lastWriteWins() throws {
        let writer = CaptureOutputWriter()
        let envelope = OutputEnvelope(data: ["status": "authorized"])
        try writer.write(envelope)

        let error = CLIErrorResponse(code: "overwrite", message: "Second write")
        try writer.writeError(error)

        let captured = try #require(writer.capturedString)
        #expect(captured.contains("overwrite"))
    }
}
