//
//  NetworkManager.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit
import CoreData

protocol NetworkManagerProtocol {
    func fetchSongs(with term: String, completion: @escaping (Result<[Song], Error>) -> Void)
  func fetchSongsInAlbum(with collectionId: Int, completion: @escaping (Result<[Song], Error>) -> Void)

}

class NetworkManager: NetworkManagerProtocol {
    private let baseURL = "https://itunes.apple.com"
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
  func fetchSongsInAlbum(with collectionId: Int, completion: @escaping (Result<[Song], Error>) -> Void) {
      var components = URLComponents(string: baseURL)
      components?.path = "/lookup"
      components?.queryItems = [
          URLQueryItem(name: "id", value: String(collectionId)),
          URLQueryItem(name: "entity", value: "song"),
          URLQueryItem(name: "kind", value: "song"),
          URLQueryItem(name: "country", value: "tr"),
          URLQueryItem(name: "attribute", value: "mixTerm")
      ]

      guard let url = components?.url else {
          print("Invalid URL")
          return
      }

      let task = session.dataTask(with: url) { (data, response, error) in
          if let error = error {
              completion(.failure(error))
          } else if let data = data {
              do {
                  let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                  completion(.success(searchResponse.results))
              } catch let decodingError {
                  completion(.failure(decodingError))
              }
          }
      }

      task.resume()
  }
  
  func fetchSongs(with term: String, completion: @escaping (Result<[Song], Error>) -> Void) {
      let encodedTerm = term.replacingOccurrences(of: " ", with: "+")
      var components = URLComponents(string: baseURL)
      components?.path = "/search"
      components?.queryItems = [
          URLQueryItem(name: "term", value: encodedTerm),
          URLQueryItem(name: "entity", value: "song"),
          URLQueryItem(name: "kind", value: "song"),
          URLQueryItem(name: "country", value: "tr"),
          URLQueryItem(name: "attribute", value: "mixTerm")
      ]

      guard let url = components?.url else {
          print("Invalid URL")
          return
      }

        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            }
        }

        task.resume()
    }
}



extension Song {
    var isFavorite: Bool {
        let fetchRequest: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackId = %d", trackId ?? 0)
        do {
            let favoriteSongs = try CoreDataManager.shared.context.fetch(fetchRequest)
            return !favoriteSongs.isEmpty
        } catch {
            print("Failed to fetch favorite song: \(error)")
            return false
        }
    }
}
