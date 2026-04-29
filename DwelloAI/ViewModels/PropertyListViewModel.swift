//
//  PropertyListViewModel.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 29.04.2026.
//

import Foundation
import Combine

final class PropertyListViewModel: ObservableObject {
    @Published var properties: [Property] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let propertyService: PropertyServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(propertyService: PropertyServiceProtocol) {
        self.propertyService = propertyService
    }
    
    var hotDeals: [Property] {
        Array(properties.prefix(6))
    }
    
    func loadProperties() {
        isLoading = true
        errorMessage = nil
        
        propertyService.fetchProperties()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] properties in
                self?.properties = properties
            }
            .store(in: &cancellables)
    }
}
