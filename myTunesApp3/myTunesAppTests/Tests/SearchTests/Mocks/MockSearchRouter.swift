//
//  SearchRouterProtocolMock.swift
//  myTunesAppTests
//
//  Created by TestUser on 16.06.2023.
//

import Foundation
@testable import myTunesApp

final class MockSearchRouter: SearchRouterProtocol {

    weak var view: SearchViewController?
    var isInvokedGoToSongDetail = false
    var invokedGoToSongDetailCount = 0
    var invokedGoToSongDetailParameter: Song?

    static func createModule() -> SearchViewController {
        return SearchViewController()
    }

    func goToSongDetail(forSong song: Song) {
        isInvokedGoToSongDetail = true
        invokedGoToSongDetailCount += 1
        invokedGoToSongDetailParameter = song
    }

    func pushToSongDetail(with song: Song) {
        isInvokedGoToSongDetail = true
        invokedGoToSongDetailCount += 1
        invokedGoToSongDetailParameter = song
    }

}
