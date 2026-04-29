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
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 22)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: -4)
        )
    }
    
    private func tabButton(_ tab: TabItem) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Image(systemName: selectedTab == tab ? tab.selectedIcon : tab.icon)
                        .font(.system(size: iconSize(for: tab), weight: .medium))
                        .symbolRenderingMode(.monochrome)
                        .frame(width: 32, height: 32)
                }
                .frame(width: 36, height: 36)
                
                Text(tab.title)
                    .font(.custom("Poppins-Medium", size: 12))
                    .lineLimit(1)
            }
            .foregroundStyle(selectedTab == tab ? accentColor : inactiveColor)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var addButton: some View {
        Button {
            selectedTab = .add
        } label: {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 70, height: 70)
                
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .offset(y: -14)
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
            return 34
        }
    }
}
