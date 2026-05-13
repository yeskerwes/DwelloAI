//
//  ThemeManager.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import SwiftUI
import Combine

private let kThemeKey = "dwello_theme"

final class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: AppTheme

    init() {
        let saved = UserDefaults.standard.string(forKey: kThemeKey) ?? "system"
        self.currentTheme = AppTheme(rawValue: saved) ?? .system
    }

    var colorScheme: ColorScheme? {
        currentTheme.colorScheme
    }

    func set(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: kThemeKey)
        currentTheme = theme
    }
}
