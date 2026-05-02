//
//  CustomTabBar.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    private let accentColor = Color("AccentColor")
    private let inactiveColor = Color.gray
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            tabButton(.favorite)
            addButton
            tabButton(.chat)
            tabButton(.profile)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 78)
        .padding(.horizontal, 12)
        .background(
            Color.white
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: -4)
        )
    }
    
    private func tabButton(_ tab: TabItem) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: selectedTab == tab ? tab.selectedIcon : tab.icon)
                    .font(.system(size: iconSize(for: tab), weight: .medium))
                    .symbolRenderingMode(.monochrome)
                    .frame(width: 34, height: 34)
                
                Text(tab.title)
                    .font(.custom("Poppins-Medium", size: 12))
                    .lineLimit(1)
            }
            .foregroundStyle(selectedTab == tab ? accentColor : inactiveColor)
            .frame(width: 64, height: 58)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    
    private var addButton: some View {
        Button {
            selectedTab = .add
        } label: {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 58, height: 58)
                
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
            }
            .frame(width: 64, height: 58)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .offset(y: -4)
    }
    
    private func iconSize(for tab: TabItem) -> CGFloat {
        switch tab {
        case .home:
            return 27
        case .favorite:
            return 29
        case .chat:
            return 27
        case .profile:
            return 31
        case .add:
            return 28
        }
    }
}
