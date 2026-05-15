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
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAppLaunchShowsHomeContent() {
        let header = app.staticTexts["Find your dream Home"]
        XCTAssertTrue(header.waitForExistence(timeout: 5), "Home header should be visible on launch")
    }

    func testHomeViewShowsHotDealsSection() {
        let hotDeals = app.staticTexts["Hot deals in your city"]
        XCTAssertTrue(hotDeals.waitForExistence(timeout: 5), "Hot deals section should be visible on home screen")
    }

    func testNavigateToProfileTab() {
        let profileButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Profile'")
        ).firstMatch
        XCTAssertTrue(profileButton.waitForExistence(timeout: 5))
        profileButton.tap()
        XCTAssertTrue(app.exists)
    }
}
