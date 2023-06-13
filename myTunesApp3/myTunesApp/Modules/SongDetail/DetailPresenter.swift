//
//  DetailPresenter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    var song: Song? { get set }
  func didTapPlayButton(for song: Song)
  func didTapPauseButton(for song: Song)
  func didTapFavoriteButton()
  func didTapUnfavoriteButton()

    func viewDidLoad()

}

class DetailPresenter: DetailPresenterProtocol, DetailInteractorOutputProtocol {
  weak var view: DetailViewProtocol?
  var interactor: DetailInteractorInputProtocol?
  var router: DetailRouterProtocol?
  var song: Song?

  func viewDidLoad() {
    if let song = song {
      view?.displaySongDetails(song)
      if let artworkURL = URL(string: song.artworkUrl100!) {
        interactor?.loadArtwork(from: artworkURL)
      }
      if let collectionPrice = song.collectionPrice {
        view?.displayCollectionPrice(collectionPrice)
      }
      if let collectionId = song.collectionId {
        interactor?.loadSongsInAlbum(collectionId: collectionId)
      }
    }
  }
    func didRetrieveArtwork(_ data: Data) {
      DispatchQueue.main.async {
        if let image = UIImage(data: data) {
          self.view?.displayArtwork(image)
        } else {
          self.view?.displayPlaceholderArtwork()
        }
      }
    }

  func didRetrieveAlbumSongs(_ songs: [Song]) {
      DispatchQueue.main.async {
          self.view?.displayAlbumSongs(songs)
      }
  }

  func didTapPlayButton(for song: Song) {
      interactor?.playSong(song)
      self.song = song
  }
  func didTapFavoriteButton() {
    print("Favorite button tapped")

      guard let song = song else { return }
      interactor?.favoriteSong(song)
  }

  func didTapUnfavoriteButton() {
    print("Unfavorite button tapped")

      guard let song = song else { return }
      interactor?.removeFavoriteSong(song)
  }
  func didTapPauseButton(for song: Song) {
      if self.song == song {
          interactor?.pauseSong(song)
      }
  }

    func didFailToRetrieveAlbumSongs(_ error: Error) {
      print("Failed to load album songs: \(error)")
    }

    func didFailToRetrieveArtwork(_ error: Error) {
      print("Failed to load image: \(error)")
      DispatchQueue.main.async {
        self.view?.displayPlaceholderArtwork()
      }
    }
  }

extension Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
