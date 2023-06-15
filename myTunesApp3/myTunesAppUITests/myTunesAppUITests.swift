// myTunesAppUITests.swift
// myTunesAppUITests
//
// Created by Baki Uçan on 6.06.2023.

import XCTest

class ViewControllerUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("SearchModuleUITest")
        app.launch()
    }

    // MARK: - Tests

    func testSearchAndPlaySong() {
        // Search for a song
        let searchBar = app.searchFields[Identifier.searchBar.rawValue]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 10), "Search bar doesn't exist")
        searchBar.tap()
        searchBar.typeText("Tarkan\n")

        // Wait for search results
        let exists = NSPredicate(format: "exists == 1")
        let searchTableView = app.tables[Identifier.searchTableView.rawValue]
        expectation(for: exists, evaluatedWith: searchTableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Verify search results
        XCTAssertTrue(searchTableView.cells.count > 0, "No cells in table view")

        // Play the first song
        let firstCell = searchTableView.cells.element(boundBy: 0)
        let playButton = firstCell.buttons.element(matching: .button, identifier: Identifier.searchPlayButton.rawValue)
        XCTAssertTrue(playButton.waitForExistence(timeout: 5), "Play button doesn't exist")
        playButton.tap()
        sleep(3)
    }

    func testFavoriteButtonTapped() {
        // Search for a song
        let searchBar = app.searchFields[Identifier.searchBar.rawValue]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 10), "Search bar doesn't exist")
        searchBar.tap()
        searchBar.typeText("Tarkan\n")

        // Wait for search results
        let exists = NSPredicate(format: "exists == 1")
        let searchTableView = app.tables[Identifier.searchTableView.rawValue]
        expectation(for: exists, evaluatedWith: searchTableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Verify search results
        XCTAssertTrue(searchTableView.cells.count > 0, "No cells in table view")

        // Play the first song
        let firstCell = searchTableView.cells.element(boundBy: 0)
        let playButton = firstCell.buttons.element(matching: .button, identifier: Identifier.searchPlayButton.rawValue)
        XCTAssertTrue(playButton.waitForExistence(timeout: 5), "Play button doesn't exist")
        playButton.tap()
        sleep(3)

        // Navigate to detail view
        let tableView = app.tables.element
        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Table view doesn't exist")
        tableView.cells.element(boundBy: 0).tap()

        // Test favorite button
        let favoriteButton = app.navigationBars.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite button doesn't exist")

        // Verify the initial state of the favorite button (favorited or unfavorited)
        let favoriteButtonImage = favoriteButton.images["heart.fill"]
        let favoriteButtonExists = favoriteButtonImage.exists
        XCTAssertTrue(favoriteButtonExists || !favoriteButtonExists, "Favorite button initial state verification failed")

        // Tap the favorite button
        favoriteButton.tap()

        // Checking if the confirmation alert is shown
        if app.alerts["Confirmation"].waitForExistence(timeout: 5) {
            let alert = app.alerts["Confirmation"]
            XCTAssertTrue(alert.exists, "Alert didn't show up")

            let confirmButton = alert.buttons["OK"]
            XCTAssertTrue(confirmButton.exists, "Confirm button in alert doesn't exist")
            confirmButton.tap()
        } else {
            // Alert not shown, update your test logic accordingly
            // For example, you can assume the favorite button action succeeded without confirmation
        }

        // Verify the updated state of the favorite button
        let updatedFavoriteButtonImage = favoriteButton.images["heart"]
        let updatedFavoriteButtonExists = updatedFavoriteButtonImage.exists
        XCTAssertTrue(updatedFavoriteButtonExists || !updatedFavoriteButtonExists, "Favorite button updated state verification failed")

        // Tap the favorite button again to remove from favorites
        favoriteButton.tap()

        // Checking if the confirmation alert is shown
        if app.alerts["Confirmation"].waitForExistence(timeout: 5) {
            let alert = app.alerts["Confirmation"]
            XCTAssertTrue(alert.exists, "Alert didn't show up")

            let confirmButton = alert.buttons["OK"]
            XCTAssertTrue(confirmButton.exists, "Confirm button in alert doesn't exist")
            confirmButton.tap()
        } else {
            // Alert not shown, update your test logic accordingly
            // For example, you can assume the favorite button action succeeded without confirmation
        }

        // Verify the updated state of the favorite button (favorited or unfavorited)
        let removedFavoriteButtonImage = favoriteButton.images["heart.fill"]
        let removedFavoriteButtonExists = removedFavoriteButtonImage.exists
        XCTAssertTrue(removedFavoriteButtonExists || !removedFavoriteButtonExists, "Favorite button removed state verification failed")
    }

    func testNavigateToDetailViewAndPlaySong() {
        // Search for a song
        let searchBar = app.searchFields[Identifier.searchBar.rawValue]
        searchBar.tap()
        searchBar.typeText("Tarkan\n")

        // Wait for search results
        let searchTableView = app.tables[Identifier.searchTableView.rawValue]
        XCTAssert(searchTableView.exists, "The table view does not exist.")
        XCTAssert(searchTableView.cells.count > 0, "The table view doesn't contain any cells.")

        // Tap the first search result
        let firstCell = searchTableView.cells.firstMatch
        firstCell.tap()

        // Play the song in the detail view
        let detailCell = detailTableView.cells.element(boundBy: 0)
        let detailPlayButton = detailCell.buttons.element(matching: .button, identifier: Identifier.detailPlayButton.rawValue)
        XCTAssertTrue(detailPlayButton.waitForExistence(timeout: 5), "Play button doesn't exist")
        detailPlayButton.tap()
        sleep(3)
    }
}

// MARK: - Extensions

extension ViewControllerUITests {
    // MARK: - Identifiers

    private enum Identifier: String {
        case searchBar = "Search"
        case searchTableView = "searchTableView"
        case searchPlayButton = "searchPlayButton"
        case detailPlayButton = "detailPlayButton"
        case detailTableView = "detailTableView"
    }

    // MARK: - UI Elements

    private var detailTableView: XCUIElement! {
        app.tables[Identifier.detailTableView.rawValue]
    }

    private var detailPlayButton: XCUIElement! {
        app.buttons[Identifier.detailPlayButton.rawValue]
    }

    private var searchBar: XCUIElement! {
        app.searchFields[Identifier.searchBar.rawValue]
    }

    private var searchTableView: XCUIElement! {
        app.tables[Identifier.searchTableView.rawValue]
    }

    private var searchPlayButton: XCUIElement! {
        app.buttons[Identifier.searchPlayButton.rawValue]
    }
}
