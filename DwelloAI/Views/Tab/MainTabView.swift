//
//  MainTabView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            selectedContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder
    private var selectedContent: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .favorite:
            FavoriteView()
        case .add:
            AddPropertyView()
        case .chat:
            ChatView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    MainTabView()
}
