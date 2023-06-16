//
//  SearchPresenterTests.swift
//  myTunesAppTests
//
//  Created by TestUser on 16.06.2023.
//

import XCTest
@testable import myTunesApp

final class SearchPresenterTests: XCTestCase {

    var presenter: SearchPresenter!
    var view: MockSearchViewController!
    var interactor: MockSearchInteractor!
    var router: MockSearchRouter!


    override func setUp() {
        super.setUp()

        view = MockSearchViewController()
        interactor = MockSearchInteractor()
        router = MockSearchRouter()
        presenter = SearchPresenter(view: view, interactor: interactor, router: router)

    }

    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }

    func test_viewDidLoad_InvokesRequiredViewMethods() {

        XCTAssertFalse(view.isInvokedSetupSearchController)
        XCTAssertFalse(view.isInvokedSetupTableView)

        presenter.viewDidLoad()

        XCTAssertTrue(view.isInvokedSetupSearchController)
        XCTAssertTrue(view.isInvokedSetupTableView)

    }

    func test_searchSong_InvokesInteractorMethod() {

        XCTAssertFalse(interactor.isInvokedSearchSong)
        XCTAssertEqual(interactor.invokedSearchSongCount, 0)
        XCTAssertNil(interactor.invokedSearchSongTerm)

        presenter.searchSong(with: "test")

        XCTAssertTrue(interactor.isInvokedSearchSong)
        XCTAssertEqual(interactor.invokedSearchSongCount, 1)
        XCTAssertEqual(interactor.invokedSearchSongTerm, "test")

    }

  func test_didRetrieveSongs_ShowsSongsInTableView() {
      // Arrange
      let songs: [Song] = SearchResponse.response.results
      let view = MockSearchViewController()
      let interactor = MockSearchInteractor()
      let router = MockSearchRouter()
      let presenter = SearchPresenter(view: view, interactor: interactor, router: router)

      // Act
      presenter.didRetrieveSongs(songs)

      // Assert
      XCTAssertTrue(view.isInvokedShowSongs)
      XCTAssertEqual(view.invokedShowSongsCount, 1)
      XCTAssertEqual(view.invokedShowSongsParameter, songs)
      XCTAssertTrue(view.isInvokedHideLoading)
      XCTAssertFalse(view.isInvokedShowError)
      XCTAssertEqual(view.invokedShowErrorCount, 0)
      XCTAssertNil(view.invokedShowErrorMessage)
  }
}

extension SearchResponse {

    static var response: SearchResponse {
        let bundle = Bundle(for: SearchPresenterTests.self)
        let path = bundle.path(forResource: "Songs", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let response = try! JSONDecoder().decode(SearchResponse.self, from: data)
        return response
    }
}
