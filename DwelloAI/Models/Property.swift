//
//  Property.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import Foundation

struct Property: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let city: String
    let address: String
    let price: Int
    let propertyType: PropertyType
    let listingType: ListingType
    let rooms: Int
    let area: Double
    let floor: Int
    let totalFloors: Int
    let imageName: String
    let description: String
    let latitude: Double
    let longitude: Double
}

enum PropertyType: String, Codable, CaseIterable {
    case apartment
    case house
    case office
}

enum ListingType: String, Codable, CaseIterable {
    case sale
    case rent
}
