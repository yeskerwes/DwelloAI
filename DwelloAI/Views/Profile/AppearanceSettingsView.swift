//
//  AppearanceSettingsView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                themeCard
                languageCard
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGray6))
        .navigationTitle(Text("Appearance"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension AppearanceSettingsView {
    var themeCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(icon: "paintbrush.fill", title: "Change Theme")

            ForEach(Array(AppTheme.allCases.enumerated()), id: \.element.id) { index, theme in
                if index > 0 {
                    Divider().padding(.leading, 16)
                }

                Button {
                    themeManager.set(theme)
                } label: {
                    themeRow(theme)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    func themeRow(_ theme: AppTheme) -> some View {
        HStack(spacing: 14) {
            Image(systemName: theme.icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 28, height: 28)

            Text(theme.displayName)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(.primary)

            Spacer()

            if themeManager.currentTheme == theme {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("AccentColor"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .contentShape(Rectangle())
    }
}

private extension AppearanceSettingsView {
    var languageCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(icon: "globe", title: "Language")

            ForEach(Array(AppLanguage.allCases.enumerated()), id: \.element.id) { index, language in
                if index > 0 {
                    Divider().padding(.leading, 16)
                }

                Button {
                    languageManager.set(language)
                } label: {
                    languageRow(language)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    func languageRow(_ language: AppLanguage) -> some View {
        HStack(spacing: 14) {
            Text(language.displayName)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(.primary)

            Spacer()

            if languageManager.currentLanguage == language {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("AccentColor"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .contentShape(Rectangle())
    }
}

private extension AppearanceSettingsView {
    func cardHeader(icon: String, title: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 32, height: 32)
                .background(Color("AccentColor").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 9))

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
    }
}

#Preview {
    NavigationStack {
        AppearanceSettingsView()
            .environmentObject(LanguageManager())
            .environmentObject(ThemeManager())
    }
}
