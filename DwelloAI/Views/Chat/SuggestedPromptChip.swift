//
//  SuggestedPromptChip.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 13.05.2026.
//

import SwiftUI

struct SuggestedPromptChip: View {
    let text: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(LocalizedStringKey(text))
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundStyle(Color("AccentColor"))
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color("AccentColor").opacity(0.08))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color("AccentColor").opacity(0.25), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
