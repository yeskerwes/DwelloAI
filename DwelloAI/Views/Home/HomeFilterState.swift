//
//  HomeFilterState.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct HomeFilterState {
    var selectedMode: ListingMode = .buy
    var selectedCity: String? = nil
    var selectedMaxPrice: Int? = nil
    var selectedRooms: Int? = nil
    var selectedMinArea: Double? = nil
    var selectedPropertyType: PropertyTypeFilter? = nil
}

enum ListingMode: String, CaseIterable, Identifiable {
    case buy
    case rent

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .buy:
            return "Buy"
        case .rent:
            return "Rent"
        }
    }
}

enum PropertyTypeFilter: String, CaseIterable, Identifiable {
    case apartment
    case house
    case office

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .apartment:
            return "Apartments"
        case .house:
            return "House"
        case .office:
            return "Office"
        }
    }
}

enum HomeFilterSheetType: Identifiable {
    case city
    case price
    case rooms
    case area
    case propertyType

    var id: String {
        switch self {
        case .city:
            return "city"
        case .price:
            return "price"
        case .rooms:
            return "rooms"
        case .area:
            return "area"
        case .propertyType:
            return "propertyType"
        }
    }

    var title: String {
        switch self {
        case .city:
            return "Select city"
        case .price:
            return "Select price"
        case .rooms:
            return "Select rooms"
        case .area:
            return "Select square"
        case .propertyType:
            return "Property type"
        }
    }
}
