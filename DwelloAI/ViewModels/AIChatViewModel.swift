//
//  AIChatViewModel.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import Foundation
import Combine

@MainActor
final class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    @Published var navigateToResults: Bool = false
    @Published var searchResults: [Property] = []

    private(set) var lastUserQuery: String = ""

    let suggestedPrompts: [String] = [
        "Apartment in Almaty under 30M",
        "House in Astana for a family",
        "Rental apartment in Shymkent",
        "2-room apartment near the centre",
        "Affordable apartment for a student"
    ]

    private let propertyService: PropertyServiceProtocol
    private let languageManager: LanguageManager
    private var cancellables = Set<AnyCancellable>()
    private var allProperties: [Property] = []

    init(propertyService: PropertyServiceProtocol = LocalPropertyService(),
         languageManager: LanguageManager = LanguageManager()) {
        self.propertyService = propertyService
        self.languageManager = languageManager
    }

    func onAppear() {
        if messages.isEmpty {
            messages.append(ChatMessage(
                text: languageManager.localized("Hello! I'm here to help you find the perfect property. What are you looking for?"),
                time: formattedTime(),
                isFromCurrentUser: false
            ))
        }
        loadProperties()
    }

    func send(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        lastUserQuery = trimmed
        inputText = ""

        messages.append(ChatMessage(text: trimmed, time: formattedTime(), isFromCurrentUser: true))

        isTyping = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            self.isTyping = false
            self.messages.append(ChatMessage(
                text: self.languageManager.localized("I found some great matches for you. Showing results now."),
                time: self.formattedTime(),
                isFromCurrentUser: false
            ))

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.searchResults = self.filterProperties(query: trimmed)
                self.navigateToResults = true
            }
        }
    }

    private func loadProperties() {
        propertyService.fetchProperties()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] props in
                self?.allProperties = props
            })
            .store(in: &cancellables)
    }

    private func filterProperties(query: String) -> [Property] {
        var filtered = allProperties
        let lower = query.lowercased()

        if lower.contains("almaty") {
            filtered = filtered.filter { $0.city.lowercased().contains("almaty") }
        } else if lower.contains("astana") {
            filtered = filtered.filter { $0.city.lowercased().contains("astana") }
        } else if lower.contains("shymkent") {
            filtered = filtered.filter { $0.city.lowercased().contains("shymkent") }
        }

        if lower.contains("rent") || lower.contains("rental") {
            filtered = filtered.filter { $0.listingType == .rent }
        }

        if lower.contains("house") && !lower.contains("apartment") {
            filtered = filtered.filter { $0.propertyType == .house }
        }

        if let maxPrice = extractPrice(from: lower) {
            filtered = filtered.filter { $0.price <= maxPrice }
        }

        return filtered.isEmpty ? allProperties : filtered
    }

    private func extractPrice(from text: String) -> Int? {
        let pattern = #"(\d+)\s*m"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let range = Range(match.range(at: 1), in: text),
              let value = Int(text[range]) else { return nil }
        return value * 1_000_000
    }

    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
