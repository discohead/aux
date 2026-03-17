import Foundation

public struct MusicKitToDTOMapper {
    // These methods will be called by live services with actual MusicKit types.
    // Since MusicKit types can't be referenced without the framework,
    // we define generic mapping helpers here.

    public static func formatDuration(_ seconds: Double?) -> Double? {
        guard let s = seconds else { return nil }
        return (s * 100).rounded() / 100
    }

    public static func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    public static func formatArtworkURL(_ url: URL?, width: Int = 300, height: Int = 300) -> String? {
        guard let url = url else { return nil }
        return url.absoluteString
            .replacingOccurrences(of: "{w}", with: "\(width)")
            .replacingOccurrences(of: "{h}", with: "\(height)")
            .replacingOccurrences(of: "%7Bw%7D", with: "\(width)")
            .replacingOccurrences(of: "%7Bh%7D", with: "\(height)")
    }
}
