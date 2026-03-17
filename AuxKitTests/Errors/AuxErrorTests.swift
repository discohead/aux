//
//  AuxErrorTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct AuxErrorTests {

    // MARK: - Exit code mapping

    @Test func notAuthorizedHasCorrectExitCode() {
        let error = AuxError.notAuthorized(message: "test")
        #expect(error.exitCode == .notAuthorized)
    }

    @Test func notFoundHasCorrectExitCode() {
        let error = AuxError.notFound(message: "test")
        #expect(error.exitCode == .notFound)
    }

    @Test func networkErrorHasCorrectExitCode() {
        let error = AuxError.networkError(message: "test")
        #expect(error.exitCode == .networkError)
    }

    @Test func serviceErrorHasCorrectExitCode() {
        let error = AuxError.serviceError(message: "test")
        #expect(error.exitCode == .serviceError)
    }

    @Test func subscriptionRequiredHasCorrectExitCode() {
        let error = AuxError.subscriptionRequired(message: "test")
        #expect(error.exitCode == .subscriptionRequired)
    }

    @Test func unavailableHasCorrectExitCode() {
        let error = AuxError.unavailable(message: "test")
        #expect(error.exitCode == .unavailable)
    }

    @Test func generalFailureHasCorrectExitCode() {
        let error = AuxError.generalFailure(message: "test")
        #expect(error.exitCode == .generalFailure)
    }

    @Test func usageErrorHasCorrectExitCode() {
        let error = AuxError.usageError(message: "test")
        #expect(error.exitCode == .usageError)
    }

    @Test func appleScriptErrorHasCorrectExitCode() {
        let error = AuxError.appleScriptError(message: "test")
        #expect(error.exitCode == .serviceError)
    }

    // MARK: - Code string mapping

    @Test func codeStringsAreCorrect() {
        #expect(AuxError.notAuthorized(message: "").code == "not_authorized")
        #expect(AuxError.notFound(message: "").code == "not_found")
        #expect(AuxError.networkError(message: "").code == "network_error")
        #expect(AuxError.serviceError(message: "").code == "service_error")
        #expect(AuxError.subscriptionRequired(message: "").code == "subscription_required")
        #expect(AuxError.unavailable(message: "").code == "unavailable")
        #expect(AuxError.generalFailure(message: "").code == "general_failure")
        #expect(AuxError.usageError(message: "").code == "usage_error")
        #expect(AuxError.appleScriptError(message: "").code == "applescript_error")
    }

    // MARK: - CLIErrorResponse conversion

    @Test func toCLIErrorResponseProducesValidJSON() throws {
        let error = AuxError.notFound(message: "Song not found")
        let response = error.toCLIErrorResponse()
        let json = try JSONEncoder().encode(response)
        let dict = try JSONSerialization.jsonObject(with: json) as! [String: Any]
        let errorBody = dict["error"] as! [String: Any]
        #expect(errorBody["code"] as? String == "not_found")
        #expect(errorBody["message"] as? String == "Song not found")
    }
}
