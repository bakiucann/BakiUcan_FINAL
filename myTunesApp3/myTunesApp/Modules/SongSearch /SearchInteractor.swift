//
//  SearchInteractor.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

protocol SearchInteractorInputProtocol: AnyObject {
    var presenter: SearchInteractorOutputProtocol? { get set }
    func searchSong(with term: String)
}

protocol SearchInteractorOutputProtocol: AnyObject {
    func didRetrieveSongs(_ songs: [Song])
    func onError()
}

class SearchInteractor: SearchInteractorInputProtocol {
    weak var presenter: SearchInteractorOutputProtocol?


    func searchSong(with term: String) {
        NetworkManager().fetchSongs(with: term) { (result) in
            switch result {
            case .success(let songs):
                self.presenter?.didRetrieveSongs(songs)
            case .failure:
                self.presenter?.onError()
            }
        }
    }
}
