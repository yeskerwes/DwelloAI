//
//  ChatMessage.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let time: String
    let isFromCurrentUser: Bool
}
