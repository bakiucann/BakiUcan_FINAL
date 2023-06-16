//
//  AudioPlayer+Extension.swift
//  myTunesApp
//
//  Created by Baki Uçan on 14.06.2023.
//

import AVFoundation

// MARK: - AudioPlayerService

class AudioPlayerService {
    static let shared = AudioPlayerService()

    private var player: AVPlayer?
    private var currentPlaybackTime: CMTime?
    private var playerItemURL: URL?

    /// Plays audio from the specified URL.
    /// - Parameter url: The URL of the audio to be played.
    func play(url: URL) {
        if url != playerItemURL {
            currentPlaybackTime = nil
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        if let time = currentPlaybackTime {
            player?.seek(to: time)
        }
        player?.play()
        playerItemURL = url
    }

    /// Pauses the audio playback.
    func pause() {
        currentPlaybackTime = player?.currentTime()
        player?.pause()
    }

    /// Returns a boolean value indicating whether the audio is currently playing.
    var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }
}
