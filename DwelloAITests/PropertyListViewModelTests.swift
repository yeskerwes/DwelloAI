//
//  PropertyListViewModelTests.swift
//  DwelloAITests
//
//  Created by Bakdaulet Yeskermes on 15.05.2026.
//

import XCTest
import Combine
@testable import DwelloAI

@MainActor
final class PropertyListViewModelTests: XCTestCase {
    private var mockService: MockNetworkService!
    private var viewModel: PropertyListViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = PropertyListViewModel(propertyService: mockService)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadPropertiesSuccess() {
        let properties = [makeProperty(id: 1), makeProperty(id: 2)]
        mockService.stubbedProperties = properties
        let expectation = expectation(description: "properties loaded")

        viewModel.$properties
            .dropFirst()
            .sink { loaded in
                XCTAssertEqual(loaded.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadProperties()

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadPropertiesFailureSetsErrorMessage() {
        mockService.stubbedError = URLError(.notConnectedToInternet)
        let expectation = expectation(description: "error received")

        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { message in
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadProperties()

        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testHotDealsReturnsAtMostSix() {
        mockService.stubbedProperties = (1...8).map { makeProperty(id: $0) }
        let expectation = expectation(description: "properties loaded")

        viewModel.$properties
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.loadProperties()
        wait(for: [expectation], timeout: 2.0)

        XCTAssertEqual(viewModel.hotDeals.count, 6)
    }

    func testIsLoadingResetAfterSuccess() {
        mockService.stubbedProperties = [makeProperty(id: 1)]
        let expectation = expectation(description: "properties loaded")

        viewModel.$properties
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.loadProperties()
        XCTAssertTrue(viewModel.isLoading)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(viewModel.isLoading)
    }

    private func makeProperty(id: Int) -> Property {
        Property(
            id: id, title: "Property \(id)", city: "Almaty",
            address: "Test St", price: 10_000_000,
            propertyType: .apartment, listingType: .sale,
            rooms: 2, area: 60.0, floor: 3, totalFloors: 10,
            imageName: "property-1", description: "Test",
            latitude: 43.2, longitude: 76.9
        )
    }
}
