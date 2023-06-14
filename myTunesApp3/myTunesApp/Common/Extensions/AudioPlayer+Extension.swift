//
//  AudioPlayer+Extension.swift
//  myTunesApp
//
//  Created by Baki Uçan on 14.06.2023.
//

import AVFoundation

class AudioPlayerService {
    static let shared = AudioPlayerService()

    private var player: AVPlayer?
    private var currentPlaybackTime: CMTime?
    private var playerItemURL: URL?

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

    func pause() {
        currentPlaybackTime = player?.currentTime()
        player?.pause()
    }

    var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }
}
