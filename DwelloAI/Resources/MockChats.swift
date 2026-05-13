//
//  MockData.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import Foundation

enum MockChats {
    static let threads: [ChatThread] = [
        ChatThread(
            name: "DwelloAI Assistant",
            subtitle: "AI real estate helper",
            lastMessage: "I can help you find the best property based on your budget.",
            time: "Pinned",
            unreadCount: 0,
            isPinned: true,
            participantType: .ai,
            avatarImageName: nil,
            avatarSystemName: "sparkles"
        ),
        ChatThread(
            name: "Aigerim",
            subtitle: "Property owner",
            lastMessage: "Yes, the apartment is still available.",
            time: "10:42",
            unreadCount: 2,
            isPinned: false,
            participantType: .user,
            avatarImageName: nil,
            avatarSystemName: "person.fill"
        ),
        ChatThread(
            name: "Madina",
            subtitle: "House owner",
            lastMessage: "The price is negotiable.",
            time: "Yesterday",
            unreadCount: 1,
            isPinned: false,
            participantType: .user,
            avatarImageName: nil,
            avatarSystemName: "person.fill"
        )
    ]

    static func messages(for thread: ChatThread) -> [ChatMessage] {
        if thread.participantType == .ai {
            return [
                ChatMessage(
                    text: "Hello! I’m DwelloAI. Tell me your city, budget, and property type.",
                    time: "10:00",
                    isFromCurrentUser: false
                ),
                ChatMessage(
                    text: "I want an apartment in Almaty under 50M ₸.",
                    time: "10:01",
                    isFromCurrentUser: true
                ),
                ChatMessage(
                    text: "Great. I found several apartments that match your preferences.",
                    time: "10:02",
                    isFromCurrentUser: false
                )
            ]
        } else {
            return [
                ChatMessage(
                    text: "Hello, is this property still available?",
                    time: "09:20",
                    isFromCurrentUser: true
                ),
                ChatMessage(
                    text: thread.lastMessage,
                    time: "09:25",
                    isFromCurrentUser: false
                )
            ]
        }
    }
}
