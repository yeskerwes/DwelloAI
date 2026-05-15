//
//  MockNetworkService.swift
//  DwelloAITests
//
//  Created by Bakdaulet Yeskermes on 15.05.2026.
//

import Combine
@testable import DwelloAI

final class MockNetworkService: PropertyServiceProtocol {
    var stubbedProperties: [Property] = []
    var stubbedError: Error?

    func fetchProperties() -> AnyPublisher<[Property], Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedProperties)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockFavoritesService: FavoritesServiceProtocol {
    var favoriteIDs: [Int] = []

    func getFavoriteIDs() -> [Int] { favoriteIDs }

    func isFavorite(propertyID: Int) -> Bool {
        favoriteIDs.contains(propertyID)
    }

    func toggleFavorite(propertyID: Int) {
        if favoriteIDs.contains(propertyID) {
            favoriteIDs.removeAll { $0 == propertyID }
        } else {
            favoriteIDs.append(propertyID)
        }
    }

    func removeFavorite(propertyID: Int) {
        favoriteIDs.removeAll { $0 == propertyID }
    }
}
