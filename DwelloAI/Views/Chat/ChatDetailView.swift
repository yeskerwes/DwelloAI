//
//  ChatDetailView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct ChatDetailView: View {
    let thread: ChatThread

    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                messagesList

                messageInput
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.white)
            }
        }
        .navigationTitle(thread.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            messages = MockChats.messages(for: thread)
        }
    }
}

private extension ChatDetailView {
    var messagesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if thread.participantType == .ai {
                    aiIntroCard
                }

                ForEach(messages) { message in
                    ChatBubbleView(message: message)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
    }

    var aiIntroCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color("AccentColor"))

            VStack(alignment: .leading, spacing: 4) {
                Text("DwelloAI Assistant")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundStyle(.black)

                Text("This chat can help you find properties, compare prices, and choose the best option.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundStyle(.gray)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(14)
        .background(Color("AccentColor").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    var messageInput: some View {
        HStack(spacing: 10) {
            TextField("Message", text: $messageText, axis: .vertical)
                .font(.custom("Poppins-Regular", size: 14))
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .lineLimit(1...4)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.gray.opacity(0.4)
                        : Color("AccentColor")
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return
        }

        let newMessage = ChatMessage(
            text: trimmed,
            time: "Now",
            isFromCurrentUser: true
        )

        messages.append(newMessage)
        messageText = ""

        if thread.participantType == .ai {
            let aiReply = ChatMessage(
                text: "I will analyze your request and suggest suitable properties soon.",
                time: "Now",
                isFromCurrentUser: false
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                messages.append(aiReply)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(thread: MockChats.threads[0])
    }
}
