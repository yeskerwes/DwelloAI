//
//  ChatView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var searchText = ""

    private var filteredChats: [ChatThread] {
        let sorted = MockChats.threads.sorted { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned && !second.isPinned
            }
            return first.name < second.name
        }

        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return sorted
        }

        return sorted.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                if authViewModel.isLoggedIn {
                    chatsContent
                } else {
                    LoginRequiredView(authViewModel: authViewModel)
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
        }
    }
}

private extension ChatsView {
    var chatsContent: some View {
        VStack(spacing: 0) {
            header

            searchBar
                .padding(.horizontal, 15)
                .padding(.top, 14)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(filteredChats) { chat in
                        NavigationLink {
                            if chat.participantType == .ai {
                                AIChatView()
                            } else {
                                ChatDetailView(thread: chat)
                            }
                        } label: {
                            ChatRowView(chat: chat)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 18)
                .padding(.bottom, 50)
            }
        }
    }

    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AI assistant and conversations")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button {

            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color("AccentColor"))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15)
        .padding(.top, 18)
    }

    var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.gray)

            TextField("Search chats", text: $searchText)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundStyle(.black)
                .textInputAutocapitalization(.never)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ChatsView()
}
