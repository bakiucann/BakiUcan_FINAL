//
//  DetailPresenter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import CoreText

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
    func attributedString(for trackName: String) -> NSAttributedString
}

class DetailPresenter: DetailPresenterProtocol, DetailInteractorOutputProtocol {
    // MARK: - Properties
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?
    var router: DetailRouterProtocol?
    var song: Song?
    var isFavorite: Bool = false

    // MARK: - Protocol Methods
    func viewDidLoad() {
        // Notify that a song started playing
        NotificationCenter.default.post(name: Notification.Name("SongStartedPlaying"), object: nil)

        if let song = song {
            view?.displaySongDetails(song)

            // Load artwork
            if let artworkURL = URL(string: song.artworkUrl100!) {
                interactor?.loadArtwork(from: artworkURL)
            }

            // Display collection price
            if let collectionPrice = song.collectionPrice {
                view?.displayCollectionPrice(collectionPrice)
            }

            // Load songs in the same album
            if let collectionId = song.collectionId {
                interactor?.loadSongsInAlbum(collectionId: collectionId)
            }
        }
    }

    func didRetrieveArtwork(_ data: Data) {
        DispatchQueue.main.async {
            if let artworkURL = URL(string: self.song?.artworkUrl100 ?? ""),
               let imageView = self.view?.getArtworkImageView() {
                imageView.loadImage(from: artworkURL) { [weak self] image in
                    if image != nil {
                        self?.view?.displayArtwork(image!)
                    } else {
                        self?.view?.displayPlaceholderArtwork()
                    }
                }
            } else {
                self.view?.displayPlaceholderArtwork()
            }
        }
    }

    func attributedString(for trackName: String) -> NSAttributedString {
        let parts = trackName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        guard parts.count == 2 else {
            return NSAttributedString(string: trackName)
        }

        let numberPart = String(parts[0])
        let spacePart = "  "
        let namePart = String(parts[1])

        let numberAttributes: [NSAttributedString.Key: Any] = [kCTFontAttributeName as NSAttributedString.Key: CTFontCreateWithName("Helvetica" as CFString, 17, nil)]
        let spaceAttributes: [NSAttributedString.Key: Any] = [kCTFontAttributeName as NSAttributedString.Key: CTFontCreateWithName("Helvetica" as CFString, 17, nil)]
        let nameAttributes: [NSAttributedString.Key: Any] = [kCTFontAttributeName as NSAttributedString.Key: CTFontCreateWithName("Helvetica-Bold" as CFString, 17, nil)]

        let attributedString = NSMutableAttributedString(string: numberPart, attributes: numberAttributes)
        attributedString.append(NSAttributedString(string: spacePart, attributes: spaceAttributes))
        attributedString.append(NSAttributedString(string: namePart, attributes: nameAttributes))

        return attributedString
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
        guard let song = song else { return }
        interactor?.favoriteSong(song)
        isFavorite = true
    }

    func didTapUnfavoriteButton() {
        guard let song = song else { return }
        interactor?.removeFavoriteSong(song)
        isFavorite = false
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
