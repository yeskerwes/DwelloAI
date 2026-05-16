//
//  DwelloAISnapshotTests.swift
//  DwelloAIUITests
//
//  Created by Bakdaulet Yeskermes on 15.05.2026.
//

import XCTest

final class DwelloAISnapshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US",
            "-dwello_language", "en",
            "UITesting"
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testHomeViewSnapshot() {
        XCTAssertTrue(
            app.staticTexts["Find your dream Home"].waitForExistence(timeout: 10),
            "Home view must be visible before taking snapshot"
        )

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "HomeView-Snapshot"
        attachment.lifetime = .keepAlways
        add(attachment)

        XCTAssertTrue(app.exists)
    }

    func testFavoriteViewSnapshot() {
        let favoriteButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Favorite'")
        ).firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 10))
        favoriteButton.tap()

        Thread.sleep(forTimeInterval: 1.0)

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "FavoriteView-Snapshot"
        attachment.lifetime = .keepAlways
        add(attachment)

        XCTAssertTrue(app.exists)
    }
}
