//
//  ChatRowView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct ChatRowView: View {
    let chat: ChatThread

    var body: some View {
        HStack(spacing: 12) {
            avatar

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(chat.name)
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    if chat.participantType == .ai {
                        aiBadge
                    }

                    if chat.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color("AccentColor"))
                    }

                    Spacer()

                    Text(chat.time)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(.gray)
                }

                Text(chat.subtitle)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(chat.participantType == .ai ? Color("AccentColor") : .gray)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(chat.lastMessage)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundStyle(.gray)
                        .lineLimit(1)

                    Spacer()

                    if chat.unreadCount > 0 {
                        Text("\(chat.unreadCount)")
                            .font(.custom("Poppins-SemiBold", size: 11))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Color("AccentColor"))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(14)
        .background(rowBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    chat.participantType == .ai
                    ? Color("AccentColor").opacity(0.35)
                    : Color.clear,
                    lineWidth: 1.2
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: chat.participantType == .ai ? Color("AccentColor").opacity(0.08) : .black.opacity(0.03),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

private extension ChatRowView {
    var avatar: some View {
        ZStack {
            Circle()
                .fill(avatarBackground)
                .frame(width: 54, height: 54)

            Image(systemName: chat.avatarSystemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(avatarIconColor)
        }
    }

    var aiBadge: some View {
        Text("AI")
            .font(.custom("Poppins-SemiBold", size: 10))
            .foregroundStyle(.white)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Color("AccentColor"))
            .clipShape(Capsule())
    }

    var rowBackground: Color {
        chat.participantType == .ai
        ? Color("AccentColor").opacity(0.08)
        : Color.white
    }

    var avatarBackground: Color {
        switch chat.participantType {
        case .ai:
            return Color("AccentColor").opacity(0.15)
        case .agent:
            return Color.orange.opacity(0.15)
        case .user:
            return Color.gray.opacity(0.15)
        }
    }

    var avatarIconColor: Color {
        switch chat.participantType {
        case .ai:
            return Color("AccentColor")
        case .agent:
            return .orange
        case .user:
            return .gray
        }
    }
}
