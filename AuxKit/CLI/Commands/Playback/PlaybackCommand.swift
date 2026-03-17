import ArgumentParser

public struct PlaybackCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "playback",
        abstract: "Control Apple Music playback",
        subcommands: [
            PlayCommand.self,
            PauseCommand.self,
            StopCommand.self,
            NextCommand.self,
            PreviousCommand.self,
            NowPlayingCommand.self,
            PlayerStatusCommand.self,
            SeekCommand.self,
            VolumeCommand.self,
            ShuffleCommand.self,
            RepeatCommand.self,
            FastForwardCommand.self,
            RewindCommand.self,
            AirPlayListCommand.self,
            AirPlaySelectCommand.self,
            AirPlayCurrentCommand.self,
            EQListPresetsCommand.self,
            EQGetCommand.self,
            EQSetCommand.self,
        ]
    )
    public init() {}
}
