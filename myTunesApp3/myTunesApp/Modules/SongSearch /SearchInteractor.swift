//
//  SearchInteractor.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

// MARK: - SearchInteractorInputProtocol

protocol SearchInteractorInputProtocol: AnyObject {
    var presenter: SearchInteractorOutputProtocol? { get set }
    func searchSong(with term: String)
}

// MARK: - SearchInteractorOutputProtocol

protocol SearchInteractorOutputProtocol: AnyObject {
    func didRetrieveSongs(_ songs: [Song])
    func onError()
}

// MARK: - SearchInteractor

class SearchInteractor: SearchInteractorInputProtocol {
    // MARK: Properties

    weak var presenter: SearchInteractorOutputProtocol?
    private let networkManager: NetworkManagerProtocol

    // MARK: Initialization

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    // MARK: Public Methods

    func searchSong(with term: String) {
        networkManager.fetchSongs(with: term) { (result) in
            switch result {
            case .success(let songs):
                self.presenter?.didRetrieveSongs(songs)
            case .failure(_):
                self.presenter?.onError()
            }
        }
    }
}
