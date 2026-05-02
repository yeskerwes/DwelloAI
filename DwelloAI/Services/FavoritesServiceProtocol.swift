//
//  FavoriteServiceProtocol.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import Foundation

protocol FavoritesServiceProtocol {
    func getFavoriteIDs() -> [Int]
    func isFavorite(propertyID: Int) -> Bool
    func toggleFavorite(propertyID: Int)
    func removeFavorite(propertyID: Int)
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
