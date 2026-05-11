//
//  ChatThread.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import Foundation

enum ChatParticipantType {
    case ai
    case user
    case agent
}

struct ChatThread: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let isPinned: Bool
    let participantType: ChatParticipantType
    let avatarImageName: String?
    let avatarSystemName: String
}
