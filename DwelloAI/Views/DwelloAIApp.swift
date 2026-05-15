//
//  DwelloAIApp.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 06.04.2026.
//

import SwiftUI

@main
struct DwelloAIApp: App {
    @StateObject private var authViewModel       = AuthViewModel(authService: MockAuthService())
    @StateObject private var userPropertyService = UserPropertyService()
    @StateObject private var languageManager     = LanguageManager()
    @StateObject private var themeManager        = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .id(languageManager.currentLanguage.rawValue)
                .environment(\.locale, languageManager.locale)
                .environmentObject(authViewModel)
                .environmentObject(userPropertyService)
                .environmentObject(languageManager)
                .environmentObject(themeManager)
        }
    }
}
