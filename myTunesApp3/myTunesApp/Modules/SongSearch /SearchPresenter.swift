//
//  SearchPresenter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import Loadable
import AlertPresentable
import AVFoundation

protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchSong(with term: String)
    func showSongDetail(forSong song: Song)
    func playButtonTapped(for song: Song, at indexPath: IndexPath)
    func songSelected(at indexPath: IndexPath)
    func song(for indexPath: IndexPath) -> Song?
    func isPlaying(for indexPath: IndexPath) -> Bool
    func numberOfSongs() -> Int
}

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    private let interactor: SearchInteractorInputProtocol
    private let router: SearchRouterProtocol
    private var songs: [Song] = []
    private var nowPlayingIndexPath: IndexPath?
    private var audioPlayer: AVPlayer?
    private var currentPlaybackTime: CMTime?

    init(view: SearchViewProtocol, interactor: SearchInteractorInputProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.setupSearchController()
        view?.setupTableView()
    }

    func searchSong(with term: String) {
        view?.showLoading()
        interactor.searchSong(with: term)
    }

    func numberOfSongs() -> Int {
        return songs.count
    }
  func showNoResults() {
      view?.showNoResults()
  }

  func showError(withMessage message: String) {
      view?.showError(withMessage: message)
  }
    func showSongDetail(forSong song: Song) {
        router.pushToSongDetail(with: song)
    }

    func playButtonTapped(for song: Song, at indexPath: IndexPath) {
      if let url = URL(string: song.previewUrl!) {
            if nowPlayingIndexPath == indexPath {
                pauseSong()
                nowPlayingIndexPath = nil
            } else {
                playSong(url: url)
                nowPlayingIndexPath = indexPath
            }
            view?.reloadData()
        }
    }

    func song(for indexPath: IndexPath) -> Song? {
        guard indexPath.row < songs.count else {
            return nil
        }
        return songs[indexPath.row]
    }

    func isPlaying(for indexPath: IndexPath) -> Bool {
        return indexPath == nowPlayingIndexPath
    }

    func songSelected(at indexPath: IndexPath) {
        guard let song = song(for: indexPath) else {
            return
        }
        showSongDetail(forSong: song)
    }

    private func playSong(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        if let time = currentPlaybackTime {
            audioPlayer?.seek(to: time)
        }
        audioPlayer?.play()
    }

    private func pauseSong() {
        audioPlayer?.pause()
        currentPlaybackTime = audioPlayer?.currentTime()
    }
}

extension SearchPresenter: SearchInteractorOutputProtocol {
  func didRetrieveSongs(_ songs: [Song]) {
      if songs.isEmpty {
          view?.showNoResults()
      } else {
          self.songs = songs
          view?.hideLoading()
          view?.showSongs(with: songs)
      }
  }


    func onError() {
        view?.hideLoading()
        view?.showError(withMessage: "An error occurred while fetching the songs.")
    }
}
