//
//  FieldParserTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

struct FieldParserTests {

    @Test func parsesValidKeyValuePairs() throws {
        let result = try FieldParser.parse("name=Hello,artist=World")
        #expect(result["name"] == "Hello")
        #expect(result["artist"] == "World")
    }

    @Test func parsesValueWithEquals() throws {
        let result = try FieldParser.parse("comment=a=b")
        #expect(result["comment"] == "a=b")
    }

    @Test func throwsOnMalformedPair() {
        #expect(throws: AuxError.self) {
            try FieldParser.parse("no_equals")
        }
    }

    @Test func throwsOnEmptyInput() {
        #expect(throws: AuxError.self) {
            try FieldParser.parse("")
        }
    }

    @Test func throwsWithMalformedMessage() {
        do {
            _ = try FieldParser.parse("bad_field")
            Issue.record("Expected error")
        } catch let error as AuxError {
            #expect(error.message.contains("Malformed"))
            #expect(error.message.contains("bad_field"))
        } catch {
            Issue.record("Wrong error type")
        }
    }

    @Test func parsesSinglePair() throws {
        let result = try FieldParser.parse("genre=Rock")
        #expect(result.count == 1)
        #expect(result["genre"] == "Rock")
    }
}
