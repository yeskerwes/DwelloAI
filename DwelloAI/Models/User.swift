//
//  User.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var fullName: String
    var email: String
    var phone: String?
    var avatarName: String?
}
