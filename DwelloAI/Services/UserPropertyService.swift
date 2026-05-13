//
//  UserPropertyService.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 11.05.2026.
//

import Foundation
import Combine

final class UserPropertyService: ObservableObject {
    @Published var userProperties: [Property] = []

    private func key(for userID: UUID) -> String {
        "userProperties_\(userID.uuidString)"
    }

    func load(for userID: UUID) {
        userProperties = stored(for: userID)
    }

    func add(_ property: Property, for userID: UUID) {
        var list = stored(for: userID)
        list.insert(property, at: 0)
        persist(list, for: userID)
        userProperties = list
    }

    func remove(_ property: Property, for userID: UUID) {
        var list = stored(for: userID)
        list.removeAll { $0.id == property.id }
        persist(list, for: userID)
        userProperties = list
    }

    func clear() {
        userProperties = []
    }

    private func stored(for userID: UUID) -> [Property] {
        guard let data = UserDefaults.standard.data(forKey: key(for: userID)),
              let list = try? JSONDecoder().decode([Property].self, from: data) else {
            return []
        }
        return list
    }

    private func persist(_ list: [Property], for userID: UUID) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key(for: userID))
        }
    }
}
