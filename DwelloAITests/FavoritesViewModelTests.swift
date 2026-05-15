//
//  FavoritesViewModelTests.swift
//  DwelloAITests
//
//  Created by Bakdaulet Yeskermes on 15.05.2026.
//

import XCTest
import Combine
@testable import DwelloAI

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    private var mockPropertyService: MockNetworkService!
    private var mockFavoritesService: MockFavoritesService!
    private var viewModel: FavoritesViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockPropertyService = MockNetworkService()
        mockFavoritesService = MockFavoritesService()
        viewModel = FavoritesViewModel(
            propertyService: mockPropertyService,
            favoritesService: mockFavoritesService
        )
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockPropertyService = nil
        mockFavoritesService = nil
        super.tearDown()
    }

    func testLoadFavoritesFiltersCorrectly() {
        mockPropertyService.stubbedProperties = (1...5).map { makeProperty(id: $0) }
        mockFavoritesService.favoriteIDs = [1, 3, 5]
        let expectation = expectation(description: "favorites loaded")

        viewModel.$favoriteProperties
            .dropFirst()
            .sink { favorites in
                XCTAssertEqual(favorites.count, 3)
                XCTAssertEqual(favorites.map(\.id).sorted(), [1, 3, 5])
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadFavorites()
        wait(for: [expectation], timeout: 2.0)
    }

    func testRemoveFromFavorites() {
        let target = makeProperty(id: 42)
        viewModel.favoriteProperties = [target, makeProperty(id: 10)]
        mockFavoritesService.favoriteIDs = [42, 10]

        viewModel.removeFromFavorites(target)

        XCTAssertFalse(viewModel.favoriteProperties.contains(where: { $0.id == 42 }))
        XCTAssertEqual(viewModel.favoriteProperties.count, 1)
        XCTAssertFalse(mockFavoritesService.isFavorite(propertyID: 42))
    }

    func testClearResetsState() {
        viewModel.favoriteProperties = [makeProperty(id: 1), makeProperty(id: 2)]
        viewModel.clear()

        XCTAssertTrue(viewModel.favoriteProperties.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }

    private func makeProperty(id: Int) -> Property {
        Property(
            id: id, title: "Property \(id)", city: "Almaty",
            address: "Addr", price: 5_000_000,
            propertyType: .apartment, listingType: .sale,
            rooms: 1, area: 40.0, floor: 1, totalFloors: 5,
            imageName: "property-1", description: "Desc",
            latitude: 43.0, longitude: 77.0
        )
    }
}
