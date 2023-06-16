//
//  SearchInteractorInputProtocolMock.swift
//  myTunesAppTests
//
//  Created by TestUser on 16.06.2023.
//

import Foundation
@testable import myTunesApp

final class MockSearchInteractor: SearchInteractorInputProtocol {

    var presenter: SearchInteractorOutputProtocol?
    var isInvokedSearchSong = false
    var invokedSearchSongCount = 0
    var invokedSearchSongTerm: String?

    func searchSong(with term: String) {
        isInvokedSearchSong = true
        invokedSearchSongCount += 1
        invokedSearchSongTerm = term
    }

}
