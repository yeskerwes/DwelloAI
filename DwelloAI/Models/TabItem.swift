//
//  TabItem.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

enum TabItem: CaseIterable {
    case home
    case favorite
    case add
    case chat
    case profile
    
    var title: LocalizedStringKey {
        switch self {
        case .home:     return "Home"
        case .favorite: return "Favorite"
        case .add:      return ""
        case .chat:     return "Chat"
        case .profile:  return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "heart"
        case .add:
            return "plus"
        case .chat:
            return "message"
        case .profile:
            return "person.crop.circle"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .favorite:
            return "heart.fill"
        case .add:
            return "plus"
        case .chat:
            return "message.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
}
