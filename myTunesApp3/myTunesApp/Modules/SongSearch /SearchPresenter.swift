//
//  SearchPresenter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import Loadable
import AlertPresentable

protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchSong(with term: String)
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

    init(view: SearchViewProtocol, interactor: SearchInteractorInputProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        NotificationCenter.default.addObserver(self, selector: #selector(handleSongStartedPlaying(_:)), name: Notification.Name("SongStartedPlaying"), object: nil)
    }

    func viewDidLoad() {
        view?.setupSearchController()
        view?.setupTableView()
    }

    @objc private func handleSongStartedPlaying(_ notification: Notification) {
        if let nowPlayingIndexPath = nowPlayingIndexPath {
            view?.updateButtonImage(at: nowPlayingIndexPath, to: "play.circle.fill")
        }
        nowPlayingIndexPath = nil
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

    func playButtonTapped(for song: Song, at indexPath: IndexPath) {
        if let url = URL(string: song.previewUrl!) {
            if let nowPlayingIndexPath = nowPlayingIndexPath, nowPlayingIndexPath == indexPath {
                if AudioPlayerService.shared.isPlaying {
                    AudioPlayerService.shared.pause()
                    view?.updateButtonImage(at: indexPath, to: "play.circle.fill")
                } else {
                    AudioPlayerService.shared.play(url: url)
                    view?.updateButtonImage(at: indexPath, to: "pause.fill")
                }
            } else {
                if let nowPlayingIndexPath = nowPlayingIndexPath {
                    view?.updateButtonImage(at: nowPlayingIndexPath, to: "play.circle.fill")
                }
                AudioPlayerService.shared.play(url: url)
                nowPlayingIndexPath = indexPath
                view?.updateButtonImage(at: indexPath, to: "pause.fill")
            }
        }
    }

    func isPlaying(for indexPath: IndexPath) -> Bool {
        guard let nowPlayingIndexPath = nowPlayingIndexPath else {
            return false
        }
        return indexPath == nowPlayingIndexPath && AudioPlayerService.shared.isPlaying
    }

    func song(for indexPath: IndexPath) -> Song? {
        guard indexPath.row < songs.count else {
            return nil
        }
        return songs[indexPath.row]
    }

    func songSelected(at indexPath: IndexPath) {
        guard let song = song(for: indexPath) else {
            return
        }
        router.goToSongDetail(forSong: song)
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
