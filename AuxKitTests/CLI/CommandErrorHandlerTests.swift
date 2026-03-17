//
//  CommandErrorHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CommandErrorHandlerTests {

    @Test func mapsAuxErrorToCorrectResponseAndExitCode() {
        let error = AuxError.notFound(message: "Track not found")
        let (response, exitCode) = CommandErrorHandler.mapError(error)
        #expect(response.error.code == "not_found")
        #expect(response.error.message == "Track not found")
        #expect(exitCode == .notFound)
    }

    @Test func mapsUsageErrorCorrectly() {
        let error = AuxError.usageError(message: "Invalid limit")
        let (response, exitCode) = CommandErrorHandler.mapError(error)
        #expect(response.error.code == "usage_error")
        #expect(response.error.message == "Invalid limit")
        #expect(exitCode == .usageError)
    }

    @Test func mapsUnavailableErrorCorrectly() {
        let error = AuxError.unavailable(message: "Not implemented")
        let (response, exitCode) = CommandErrorHandler.mapError(error)
        #expect(response.error.code == "unavailable")
        #expect(exitCode == .unavailable)
        #expect(exitCode.rawValue == 8)
    }

    @Test func mapsAppleScriptErrorCorrectly() {
        let error = AuxError.appleScriptError(message: "Script failed")
        let (response, exitCode) = CommandErrorHandler.mapError(error)
        #expect(response.error.code == "applescript_error")
        #expect(response.error.message == "Script failed")
        #expect(exitCode == .serviceError)
    }

    @Test func wrapsUnknownErrorAsGeneralFailure() {
        struct CustomError: Error, LocalizedError {
            var errorDescription: String? { "something broke" }
        }
        let error = CustomError()
        let (response, exitCode) = CommandErrorHandler.mapError(error)
        #expect(response.error.code == "general_failure")
        #expect(response.error.message == "something broke")
        #expect(exitCode == .generalFailure)
    }

    @Test func errorResponseEncodesAsJSON() throws {
        let error = AuxError.networkError(message: "timeout")
        let (response, _) = CommandErrorHandler.mapError(error)
        let data = try JSONEncoder().encode(response)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let errorObj = json["error"] as! [String: Any]
        #expect(errorObj["code"] as? String == "network_error")
        #expect(errorObj["message"] as? String == "timeout")
    }

    @Test func allAuxErrorCasesMapToCorrectExitCodes() {
        let cases: [(AuxError, AuxExitCode)] = [
            (.notAuthorized(message: ""), .notAuthorized),
            (.notFound(message: ""), .notFound),
            (.networkError(message: ""), .networkError),
            (.serviceError(message: ""), .serviceError),
            (.subscriptionRequired(message: ""), .subscriptionRequired),
            (.unavailable(message: ""), .unavailable),
            (.generalFailure(message: ""), .generalFailure),
            (.usageError(message: ""), .usageError),
            (.appleScriptError(message: ""), .serviceError),
        ]
        for (error, expectedCode) in cases {
            let (_, exitCode) = CommandErrorHandler.mapError(error)
            #expect(exitCode == expectedCode)
        }
    }
}
