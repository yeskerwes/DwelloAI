//
//  LocalFavoritesService.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import Foundation

final class LocalFavoritesService: FavoritesServiceProtocol {
    private let favoritesKey = "favoritePropertyIDs"
    
    func getFavoriteIDs() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    func isFavorite(propertyID: Int) -> Bool {
        getFavoriteIDs().contains(propertyID)
    }
    
    func toggleFavorite(propertyID: Int) {
        var ids = getFavoriteIDs()
        
        if ids.contains(propertyID) {
            ids.removeAll { $0 == propertyID }
        } else {
            ids.append(propertyID)
        }
        
        UserDefaults.standard.set(ids, forKey: favoritesKey)
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    func removeFavorite(propertyID: Int) {
        var ids = getFavoriteIDs()
        ids.removeAll { $0 == propertyID }
        
        UserDefaults.standard.set(ids, forKey: favoritesKey)
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
}
