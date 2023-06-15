//
//  DetailInteractor.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import AVFoundation
import CoreData

// MARK: - DetailInteractorInputProtocol
protocol DetailInteractorInputProtocol: AnyObject {
    var presenter: DetailInteractorOutputProtocol? { get set }
    func loadArtwork(from url: URL)
    func loadSongsInAlbum(collectionId: Int)
    func playSong(_ song: Song)
    func pauseSong(_ song: Song)
    func favoriteSong(_ song: Song)
    func removeFavoriteSong(_ song: Song)
}

// MARK: - DetailInteractorOutputProtocol
protocol DetailInteractorOutputProtocol: AnyObject {
    func didRetrieveArtwork(_ data: Data)
    func didFailToRetrieveArtwork(_ error: Error)
    func didRetrieveAlbumSongs(_ songs: [Song])
    func didFailToRetrieveAlbumSongs(_ error: Error)
}

// MARK: - DetailInteractor
class DetailInteractor: DetailInteractorInputProtocol {

    weak var presenter: DetailInteractorOutputProtocol?
    private var networkManager: NetworkManagerProtocol
    private var player: AVPlayer?
    private var audioPlayer: AVPlayer?

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

  func loadArtwork(from url: URL) {
      URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
          if let error = error {
              self?.presenter?.didFailToRetrieveArtwork(error)
          } else if let data = data {
              self?.presenter?.didRetrieveArtwork(data)
          }
      }.resume()
  }

  func playSong(_ song: Song) {
      guard let urlString = song.previewUrl, let url = URL(string: urlString) else {
          return
      }

      AudioPlayerService.shared.play(url: url)
  }

  func pauseSong(_ song: Song) {
      AudioPlayerService.shared.pause()
  }

  func favoriteSong(_ song: Song) {
      let favoriteSong = FavoriteSong(context: CoreDataManager.shared.context)
      favoriteSong.isFavorite = true
      favoriteSong.artistName = song.artistName
      favoriteSong.artworkUrl100 = song.artworkUrl100
      favoriteSong.trackId = Int32(song.trackId ?? 0)
    do {
        try CoreDataManager.shared.saveContext()
    } catch {
    }

  }

  func removeFavoriteSong(_ song: Song) {
      let fetchRequest: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "trackId = %d", song.trackId ?? 0)
        do {
            let favoriteSongs = try CoreDataManager.shared.context.fetch(fetchRequest)
            for favoriteSong in favoriteSongs {
                CoreDataManager.shared.context.delete(favoriteSong)
            }
            try CoreDataManager.shared.saveContext()
        } catch {
      }
    }

  func loadSongsInAlbum(collectionId: Int) {
      networkManager.fetchSongsInAlbum(with: collectionId) { [weak self] (result) in
          switch result {
          case .success(let songs):
              self?.presenter?.didRetrieveAlbumSongs(songs)
          case .failure(let error):
              self?.presenter?.didFailToRetrieveAlbumSongs(error)
          }
      }
   }
}

