//
//  AIChatView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import SwiftUI

struct AIChatView: View {
    @StateObject private var viewModel = AIChatViewModel()
    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            VStack(spacing: 0) {
                messagesArea
                inputArea
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
            }
        }
        .navigationTitle("AI Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToResults) {
            SearchResultsView(properties: viewModel.searchResults, query: viewModel.lastUserQuery)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension AIChatView {
    var messagesArea: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message)
                            .id(message.id)
                    }

                    if viewModel.isTyping {
                        typingIndicator
                            .id("typing")
                    }

                    if viewModel.messages.count == 1 {
                        suggestedPromptsSection
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .onAppear { scrollProxy = proxy }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isTyping) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }

    var typingIndicator: some View {
        HStack(alignment: .bottom, spacing: 6) {
            aiAvatar
            HStack(spacing: 5) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Color("AccentColor").opacity(0.6))
                        .frame(width: 7, height: 7)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(i) * 0.15),
                            value: viewModel.isTyping
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("AccentColor").opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            Spacer(minLength: 60)
        }
    }

    var aiAvatar: some View {
        Image(systemName: "sparkles")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color("AccentColor"))
            .frame(width: 28, height: 28)
            .background(Color("AccentColor").opacity(0.12))
            .clipShape(Circle())
    }

    var suggestedPromptsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try asking:")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundStyle(.gray)
                .padding(.horizontal, 4)

            FlowLayout(spacing: 8) {
                ForEach(viewModel.suggestedPrompts, id: \.self) { prompt in
                    SuggestedPromptChip(text: prompt) {
                        viewModel.send(text: prompt)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if viewModel.isTyping {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let last = viewModel.messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

private extension AIChatView {
    var inputArea: some View {
        HStack(spacing: 10) {
            TextField("Type your request...", text: $viewModel.inputText, axis: .vertical)
                .font(.custom("Poppins-Regular", size: 14))
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...4)

            Button {
                viewModel.send(text: viewModel.inputText)
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.gray.opacity(0.35)
                        : Color("AccentColor")
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .animation(.easeInOut(duration: 0.15), value: viewModel.inputText.isEmpty)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var rowX: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if rowX + size.width > width, rowX > 0 {
                height += rowHeight + spacing
                rowX = 0
                rowHeight = 0
            }
            rowX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var rowX = bounds.minX
        var rowY = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if rowX + size.width > bounds.maxX, rowX > bounds.minX {
                rowY += rowHeight + spacing
                rowX = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: rowX, y: rowY), proposal: ProposedViewSize(size))
            rowX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        AIChatView()
    }
}
