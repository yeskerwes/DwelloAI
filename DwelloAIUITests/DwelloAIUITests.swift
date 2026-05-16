//
//  DwelloAIUITests.swift
//  DwelloAIUITests
//
//  Created by Bakdaulet Yeskermes on 15.05.2026.
//


import XCTest

final class DwelloAIUITests: XCTestCase {
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

    func testAppLaunchShowsHomeContent() {
        let header = app.staticTexts["Find your dream Home"]
        XCTAssertTrue(header.waitForExistence(timeout: 10), "Home header should be visible on launch")
    }

    func testHomeViewShowsHotDealsSection() {
        let hotDeals = app.staticTexts["Hot deals in your city"]
        XCTAssertTrue(hotDeals.waitForExistence(timeout: 10), "Hot deals section should be visible on home screen")
    }

    func testNavigateToProfileTab() {
        let profileButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Profile'")
        ).firstMatch
        XCTAssertTrue(profileButton.waitForExistence(timeout: 10))
        profileButton.tap()
        XCTAssertTrue(app.exists)
    }
}
