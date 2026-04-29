//
//  ChatView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Chat Screen")
                    .font(.title)
            }
            .navigationTitle("AI Chat")
            .padding(.bottom, 90)
        }
    }
}
