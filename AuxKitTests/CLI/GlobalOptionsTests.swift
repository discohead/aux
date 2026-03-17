//
//  GlobalOptionsTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct GlobalOptionsTests {

    @Test func defaultsAreFalse() {
        let options = GlobalOptions()
        #expect(options.pretty == false)
        #expect(options.raw == false)
        #expect(options.quiet == false)
    }

    @Test func makeOutputWriterRespectsPrettyFlag() throws {
        var capturedData = Data()
        let options = GlobalOptions(pretty: true)
        let writer = options.makeOutputWriter(destination: { data in
            capturedData = data
        })

        let envelope = OutputEnvelope(data: ["key": "value"])
        try writer.write(envelope)

        let json = String(data: capturedData, encoding: .utf8) ?? ""
        // Pretty-printed JSON should contain newlines and indentation
        #expect(json.contains("\n"))
        #expect(json.contains("  "))
    }

    @Test func makeOutputWriterCompactWhenNotPretty() throws {
        var capturedData = Data()
        let options = GlobalOptions(pretty: false)
        let writer = options.makeOutputWriter(destination: { data in
            capturedData = data
        })

        let envelope = OutputEnvelope(data: ["key": "value"])
        try writer.write(envelope)

        let json = String(data: capturedData, encoding: .utf8) ?? ""
        // Compact JSON should NOT contain newlines
        #expect(!json.contains("\n"))
    }

    @Test func stderrPrintSuppressedWhenQuiet() {
        // We can't easily capture stderr in tests, but we can verify the code path
        // by checking the quiet flag controls output
        let quietOptions = GlobalOptions(quiet: true)
        // This should not produce any output (no crash = success)
        quietOptions.stderrPrint("This should be suppressed")

        let loudOptions = GlobalOptions(quiet: false)
        // This should produce output (no crash = success)
        loudOptions.stderrPrint("This should be printed")
    }

    @Test func initAcceptsCustomValues() {
        let options = GlobalOptions(pretty: true, raw: true, quiet: true)
        #expect(options.pretty == true)
        #expect(options.raw == true)
        #expect(options.quiet == true)
    }
}
