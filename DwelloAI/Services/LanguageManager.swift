//
//  LanguageManager.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import Foundation
import Combine

private let kLanguageKey = "dwello_language"

final class LanguageManager: ObservableObject {
    @Published private(set) var currentLanguage: AppLanguage

    init() {
        let saved = UserDefaults.standard.string(forKey: kLanguageKey) ?? "en"
        let language = AppLanguage(rawValue: saved) ?? .english
        self.currentLanguage = language
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let lprojBundle = Bundle(path: path) {
            self.bundle = lprojBundle
        }
    }

    var locale: Locale {
        currentLanguage.locale
    }

    /// Active lproj bundle — use this for NSLocalizedString in ViewModels
    private(set) var bundle: Bundle = .main

    func set(_ language: AppLanguage) {
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.set(language.rawValue, forKey: kLanguageKey)
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let lprojBundle = Bundle(path: path) {
            bundle = lprojBundle
        }
        currentLanguage = language
    }

    func localized(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: key, table: nil)
    }
}
