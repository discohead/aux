import Foundation

public struct AppleScriptBuilder {
    public static func tell(_ command: String) -> String {
        "tell application \"Music\" to \(command)"
    }

    public static func getProperty(_ property: String, of target: String = "") -> String {
        if target.isEmpty {
            return tell("get \(property)")
        }
        return tell("get \(property) of \(target)")
    }

    public static func setProperty(_ property: String, to value: String, of target: String = "") -> String {
        if target.isEmpty {
            return tell("set \(property) to \(value)")
        }
        return tell("set \(property) of \(target) to \(value)")
    }

    public static func getTrackProperty(_ property: String, trackId: Int) -> String {
        tell("get \(property) of (first track whose database ID is \(trackId))")
    }

    public static func setTrackProperty(_ property: String, to value: String, trackId: Int) -> String {
        tell("set \(property) of (first track whose database ID is \(trackId)) to \(value)")
    }

    public static func playCommand(trackId: Int? = nil) -> String {
        if let id = trackId {
            return tell("play (first track whose database ID is \(id))")
        }
        return tell("play")
    }

    public static func pauseCommand() -> String { tell("pause") }
    public static func stopCommand() -> String { tell("stop") }
    public static func nextTrackCommand() -> String { tell("next track") }
    public static func previousTrackCommand() -> String { tell("previous track") }

    public static func seekCommand(position: Double) -> String {
        tell("set player position to \(position)")
    }

    public static func volumeCommand(_ volume: Double) -> String {
        tell("set sound volume to \(Int(volume))")
    }

    public static func shuffleCommand(_ enabled: Bool) -> String {
        tell("set shuffle enabled to \(enabled)")
    }

    public static func repeatCommand(_ mode: String) -> String {
        tell("set song repeat to \(mode)")
    }

    public static func escapeString(_ string: String) -> String {
        string.replacingOccurrences(of: "\\", with: "\\\\")
              .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
