//
//  FavoritesViewModel.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteProperties: [Property] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let propertyService: PropertyServiceProtocol
    private var favoritesService: FavoritesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        propertyService: PropertyServiceProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.propertyService = propertyService
        self.favoritesService = favoritesService
    }

    func updateFavoritesService(_ service: FavoritesServiceProtocol) {
        favoritesService = service
    }

    func loadFavorites() {
        isLoading = true
        errorMessage = nil

        let favoriteIDs = favoritesService.getFavoriteIDs()

        propertyService.fetchProperties()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false

                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] properties in
                self?.favoriteProperties = properties.filter {
                    favoriteIDs.contains($0.id)
                }
            }
            .store(in: &cancellables)
    }

    func removeFromFavorites(_ property: Property) {
        favoritesService.removeFavorite(propertyID: property.id)
        favoriteProperties.removeAll { $0.id == property.id }
    }

    func clear() {
        favoriteProperties = []
        errorMessage = nil
    }
}
