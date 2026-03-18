import Foundation
import Testing
@testable import AuxKit

struct AuthStatusCountryCodeTests {

    @Test func encodesCountryCode() throws {
        let result = AuthStatusResult(
            authorizationStatus: "authorized",
            countryCode: "US"
        )
        let data = try JSONEncoder().encode(result)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(json["country_code"] as? String == "US")
    }

    @Test func decodesCountryCode() throws {
        let jsonString = """
        {"authorization_status":"authorized","country_code":"GB"}
        """
        let data = Data(jsonString.utf8)
        let result = try JSONDecoder().decode(AuthStatusResult.self, from: data)
        #expect(result.countryCode == "GB")
        #expect(result.authorizationStatus == "authorized")
    }

    @Test func countryCodeIsOptional() throws {
        let result = AuthStatusResult(authorizationStatus: "authorized")
        #expect(result.countryCode == nil)

        let data = try JSONEncoder().encode(result)
        let decoded = try JSONDecoder().decode(AuthStatusResult.self, from: data)
        #expect(decoded.countryCode == nil)
    }

    @Test func roundTripsWithAllFields() throws {
        let original = AuthStatusResult(
            authorizationStatus: "authorized",
            subscription: SubscriptionInfo(
                canPlayCatalogContent: true,
                canBecomeSubscriber: false,
                hasCloudLibraryEnabled: true
            ),
            countryCode: "JP"
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AuthStatusResult.self, from: data)
        #expect(decoded == original)
        #expect(decoded.countryCode == "JP")
    }
}
