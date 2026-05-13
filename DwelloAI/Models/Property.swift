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
    let ownerID: UUID?

    init(
        id: Int, title: String, city: String, address: String,
        price: Int, propertyType: PropertyType, listingType: ListingType,
        rooms: Int, area: Double, floor: Int, totalFloors: Int,
        imageName: String, description: String,
        latitude: Double, longitude: Double,
        ownerID: UUID? = nil
    ) {
        self.id = id; self.title = title; self.city = city; self.address = address
        self.price = price; self.propertyType = propertyType; self.listingType = listingType
        self.rooms = rooms; self.area = area; self.floor = floor; self.totalFloors = totalFloors
        self.imageName = imageName; self.description = description
        self.latitude = latitude; self.longitude = longitude; self.ownerID = ownerID
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        city = try c.decode(String.self, forKey: .city)
        address = try c.decode(String.self, forKey: .address)
        price = try c.decode(Int.self, forKey: .price)
        propertyType = try c.decode(PropertyType.self, forKey: .propertyType)
        listingType = try c.decode(ListingType.self, forKey: .listingType)
        rooms = try c.decode(Int.self, forKey: .rooms)
        area = try c.decode(Double.self, forKey: .area)
        floor = try c.decode(Int.self, forKey: .floor)
        totalFloors = try c.decode(Int.self, forKey: .totalFloors)
        imageName = try c.decode(String.self, forKey: .imageName)
        description = try c.decode(String.self, forKey: .description)
        latitude = try c.decode(Double.self, forKey: .latitude)
        longitude = try c.decode(Double.self, forKey: .longitude)
        ownerID = try c.decodeIfPresent(UUID.self, forKey: .ownerID)
    }
}

enum PropertyType: String, Codable, CaseIterable {
    case apartment
    case house
    case office
}

enum ListingType: String, Codable, CaseIterable, Hashable {
    case sale
    case rent
}
