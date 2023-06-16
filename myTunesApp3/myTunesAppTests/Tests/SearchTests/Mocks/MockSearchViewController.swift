//
//  SearchViewProtocolMock.swift
//  myTunesAppTests
//
//  Created by TestUser on 16.06.2023.
//

import UIKit
@testable import myTunesApp

final class MockSearchViewController: SearchViewProtocol {


  var spinner: UIActivityIndicatorView?


    var presenter: SearchPresenterProtocol?
    var isInvokedSetupSearchController = false
    var isInvokedSetupTableView = false
    var isInvokedShowSongs = false
    var invokedShowSongsCount = 0
    var invokedShowSongsParameter: [Song]?
    var isInvokedShowLoading = false
    var isInvokedHideLoading = false
    var isInvokedShowError = false
    var isInvokedNoResults = false
    var invokedShowErrorCount = 0
    var invokedShowErrorMessage: String?
    var isInvokedReloadData = false
    var isInvokedUpdateButtonImage = false
    var invokedUpdateButtonImageParameters: (indexPath: IndexPath, imageName: String)?

    func setupSearchController() {
        isInvokedSetupSearchController = true
    }

    func setupTableView() {
        isInvokedSetupTableView = true
    }
  func showNoResults() {
        isInvokedNoResults = true
  }
    func showSongs(with songs: [Song]) {
        isInvokedShowSongs = true
        invokedShowSongsCount += 1
        invokedShowSongsParameter = songs
    }

    func showLoading() {
        isInvokedShowLoading = true
    }

    func hideLoading() {
        isInvokedHideLoading = true
    }

    func showError(withMessage message: String) {
        isInvokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorMessage = message
    }

    func reloadData() {
        isInvokedReloadData = true
    }

    func updateButtonImage(at indexPath: IndexPath, to imageName: String) {
        isInvokedUpdateButtonImage = true
        invokedUpdateButtonImageParameters = (indexPath, imageName)
    }

}
