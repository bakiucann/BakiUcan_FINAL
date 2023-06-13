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

      let playerItem = AVPlayerItem(url: url)
      player = AVPlayer(playerItem: playerItem)

      player?.play()
  }

  func pauseSong(_ song: Song) {
      player?.pause()
  }
  func favoriteSong(_ song: Song) {
    print("Attempting to save song to favorites")
    print("Attempting to save song with track ID: \(song.trackId ?? 0) to favorites")

      let favoriteSong = FavoriteSong(context: CoreDataManager.shared.context)
      favoriteSong.isFavorite = true
      favoriteSong.artistName = song.artistName
      favoriteSong.artworkUrl100 = song.artworkUrl100
      favoriteSong.trackId = Int32(song.trackId ?? 0)
    do {
        try CoreDataManager.shared.saveContext()
        print("Song with track ID: \(song.trackId ?? 0) saved to favorites successfully")
    } catch {
        print("Failed to save favorite song: \(error)")
    }

  }

  func removeFavoriteSong(_ song: Song) {
    print("Attempting to remove song from favorites")
    print("Attempting to remove song with track ID: \(song.trackId ?? 0) from favorites")

      let fetchRequest: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "trackId = %d", song.trackId ?? 0)
    do {
        let favoriteSongs = try CoreDataManager.shared.context.fetch(fetchRequest)
        for favoriteSong in favoriteSongs {
            CoreDataManager.shared.context.delete(favoriteSong)
        }
        try CoreDataManager.shared.saveContext()
        print("Song with track ID: \(song.trackId ?? 0) removed from favorites successfully")
    } catch {
        print("Failed to remove favorite song: \(error)")
    }

  }

  func loadSongsInAlbum(collectionId: Int) {
      print("Loading songs for album ID: \(collectionId)")
      networkManager.fetchSongsInAlbum(with: collectionId) { [weak self] (result) in
          switch result {
          case .success(let songs):
              print("Fetched \(songs.count) songs")
              self?.presenter?.didRetrieveAlbumSongs(songs)
          case .failure(let error):
              print("Failed to fetch songs: \(error)")
              self?.presenter?.didFailToRetrieveAlbumSongs(error)
          }
      }
  }

}

