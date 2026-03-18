//
//  LiveAuthService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of AuthService using MusicKit framework.
public final class LiveAuthService: AuthService, Sendable {
    public init() {}

    public func checkStatus() async throws -> AuthStatusResult {
        let status = MusicAuthorization.currentStatus
        var countryCode: String? = nil
        if status == .authorized {
            countryCode = try? await MusicDataRequest.currentCountryCode
        }
        return AuthStatusResult(authorizationStatus: statusString(status), countryCode: countryCode)
    }

    public func requestAuthorization() async throws -> AuthStatusResult {
        let status = await MusicAuthorization.request()
        var countryCode: String? = nil
        if status == .authorized {
            countryCode = try? await MusicDataRequest.currentCountryCode
        }
        return AuthStatusResult(authorizationStatus: statusString(status), countryCode: countryCode)
    }

    public func getToken(type: String) async throws -> TokenResult {
        let status = MusicAuthorization.currentStatus
        guard status == .authorized else {
            throw AuxError.notAuthorized(
                message: "Not authorized. Current status: \(statusString(status))"
            )
        }
        // MusicKit manages tokens internally via MusicDataRequest.
        // Developer token is embedded in the app bundle; user token is not directly accessible.
        return TokenResult(
            developerToken: nil,
            userToken: nil,
            message: "MusicKit manages tokens internally. Use MusicDataRequest or the 'api' commands to make authenticated requests."
        )
    }

    // MARK: - Private

    private func statusString(_ status: MusicAuthorization.Status) -> String {
        switch status {
        case .authorized: return "authorized"
        case .denied: return "denied"
        case .notDetermined: return "not_determined"
        case .restricted: return "restricted"
        @unknown default: return "unknown"
        }
    }
}
