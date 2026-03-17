//
//  OutputEnvelopeTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct OutputEnvelopeTests {

    // MARK: - OutputEnvelope

    @Test func successEnvelopeEncodesDataField() throws {
        let envelope = OutputEnvelope(data: ["name": "Test Song"])
        let json = try JSONEncoder().encode(envelope)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        #expect(dict["data"] != nil)
        #expect(dict["error"] == nil)
    }

    @Test func successEnvelopeEncodesMetaWhenPresent() throws {
        let meta = PaginationMeta(limit: 10, offset: 0, total: 42, hasNext: true)
        let envelope = OutputEnvelope(data: "hello", meta: meta)
        let json = try JSONEncoder().encode(envelope)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        let metaDict = dict["meta"] as! [String: Any]
        #expect(metaDict["limit"] as? Int == 10)
        #expect(metaDict["total"] as? Int == 42)
        #expect(metaDict["has_next"] as? Bool == true)
    }

    @Test func successEnvelopeOmitsMetaWhenNil() throws {
        let envelope = OutputEnvelope(data: 42)
        let json = try JSONEncoder().encode(envelope)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        #expect(dict["meta"] == nil)
    }

    @Test func successEnvelopeUsesSnakeCaseKeys() throws {
        let meta = PaginationMeta(limit: 5, offset: 10, total: nil, hasNext: false)
        let envelope = OutputEnvelope(data: "x", meta: meta)
        let json = try JSONEncoder().encode(envelope)
        let str = String(data: json, encoding: .utf8)!
        #expect(str.contains("has_next"))
        #expect(!str.contains("hasNext"))
    }

    // MARK: - CLIErrorResponse

    @Test func errorResponseEncodesErrorObject() throws {
        let errResp = CLIErrorResponse(code: "not_found", message: "Song not found")
        let json = try JSONEncoder().encode(errResp)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        let error = dict["error"] as! [String: Any]
        #expect(error["code"] as? String == "not_found")
        #expect(error["message"] as? String == "Song not found")
    }

    @Test func errorResponseEncodesOptionalDetails() throws {
        let errResp = CLIErrorResponse(
            code: "service_error",
            message: "API error",
            details: ["status": AnyCodable(503)]
        )
        let json = try JSONEncoder().encode(errResp)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        let error = dict["error"] as! [String: Any]
        #expect(error["details"] != nil)
    }

    @Test func errorResponseOmitsDetailsWhenNil() throws {
        let errResp = CLIErrorResponse(code: "general_failure", message: "boom")
        let json = try JSONEncoder().encode(errResp)
        let str = String(data: json, encoding: .utf8)!
        #expect(!str.contains("details"))
    }
}
