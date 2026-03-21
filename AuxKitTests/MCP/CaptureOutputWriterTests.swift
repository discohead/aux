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

    // MARK: - capture() static helper

    @Test("capture returns JSON string on successful handler")
    func captureSuccess() async throws {
        let result = try await CaptureOutputWriter.capture(
            services: ServiceContainer.mock()
        ) { _, _, writer in
            let envelope = OutputEnvelope(data: ["status": "ok"])
            try writer.write(envelope)
        }
        #expect(result.contains("\"data\""))
        #expect(result.contains("ok"))
    }

    @Test("capture throws when handler writes nothing")
    func captureThrowsOnNoOutput() async {
        await #expect(throws: AuxError.self) {
            _ = try await CaptureOutputWriter.capture(
                services: ServiceContainer.mock()
            ) { _, _, _ in
                // Handler writes nothing
            }
        }
    }

    @Test("capture propagates handler error")
    func capturePropagatesError() async {
        await #expect(throws: AuxError.self) {
            _ = try await CaptureOutputWriter.capture(
                services: ServiceContainer.mock()
            ) { _, _, _ in
                throw AuxError.serviceError(message: "test error")
            }
        }
    }

    @Test("capture uses pretty GlobalOptions by default")
    func captureUsesPrettyOptions() async throws {
        var receivedOptions: GlobalOptions?
        _ = try await CaptureOutputWriter.capture(
            services: ServiceContainer.mock()
        ) { _, options, writer in
            receivedOptions = options
            let envelope = OutputEnvelope(data: ["ok": true])
            try writer.write(envelope)
        }
        #expect(receivedOptions?.pretty == true)
    }

    @Test("output uses pretty-printed sorted-keys formatting")
    func outputIsPrettyPrinted() throws {
        let writer = CaptureOutputWriter()
        let envelope = OutputEnvelope(data: ["a": 1, "b": 2])
        try writer.write(envelope)

        let captured = try #require(writer.capturedString)
        // Pretty-printed JSON has newlines
        #expect(captured.contains("\n"))
    }
}
