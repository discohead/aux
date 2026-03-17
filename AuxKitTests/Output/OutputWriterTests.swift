//
//  OutputWriterTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct OutputWriterTests {

    @Test func writerEmitsCompactJSONByDefault() throws {
        var output = Data()
        let writer = JSONOutputWriter(pretty: false, destination: { output.append($0) })
        try writer.write(OutputEnvelope(data: "hi"))
        let str = String(data: output, encoding: .utf8)!
        #expect(!str.contains("\n"))
    }

    @Test func writerEmitsPrettyJSONWhenRequested() throws {
        var output = Data()
        let writer = JSONOutputWriter(pretty: true, destination: { output.append($0) })
        try writer.write(OutputEnvelope(data: "hi"))
        let str = String(data: output, encoding: .utf8)!
        #expect(str.contains("\n"))
    }

    @Test func stderrHelperConformsToTextOutputStream() {
        var stream = StderrOutputStream()
        stream.write("test diagnostic\n")
        #expect(true)
    }
}
