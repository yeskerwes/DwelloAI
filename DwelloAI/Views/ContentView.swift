//
//  ContentView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 06.04.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = !CommandLine.arguments.contains("UITesting")

    var body: some View {
        ZStack {
            MainTabView()

            if showSplash {
                SplashView {
                    showSplash = false
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
