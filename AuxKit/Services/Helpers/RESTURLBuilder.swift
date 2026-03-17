import Foundation

public struct RESTURLBuilder {
    public static let baseURL = "https://api.music.apple.com"

    public static func buildURL(
        path: String,
        queryParams: [String: String]? = nil
    ) -> URL? {
        var components = URLComponents(string: baseURL + path)
        if let params = queryParams, !params.isEmpty {
            components?.queryItems = params.sorted(by: { $0.key < $1.key }).map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        return components?.url
    }

    public static func ratingsPath(type: String, id: String) -> String {
        "/v1/me/ratings/\(type)/\(id)"
    }

    public static func libraryPath(_ resource: String) -> String {
        "/v1/me/library/\(resource)"
    }

    public static func catalogPath(storefront: String, resource: String) -> String {
        "/v1/catalog/\(storefront)/\(resource)"
    }
}
