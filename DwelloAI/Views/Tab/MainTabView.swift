//
//  MainTabView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var selectedTab: TabItem = .home
    @State private var showLoginSheet = false
    @State private var showAddSheet = false
    @State private var addListingType: ListingType? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            selectedContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab, onAddTapped: handleAddTapped)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showLoginSheet) {
            NavigationStack {
                LoginView(authViewModel: authViewModel)
            }
        }
        .sheet(isPresented: $showAddSheet, onDismiss: { addListingType = nil }) {
            NavigationStack {
                ListingTypePickerSheet { type in
                    addListingType = type
                }
                .navigationDestination(item: $addListingType) { type in
                    AddPropertyView(listingType: type, onClose: {
                        showAddSheet = false
                    })
                }
            }
            .presentationDetents(addListingType == nil ? [.height(240)] : [.large])
            .presentationDragIndicator(.visible)
        }
    }

    private func handleAddTapped() {
        if authViewModel.isLoggedIn {
            addListingType = nil
            showAddSheet = true
        } else {
            showLoginSheet = true
        }
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .favorite:
            FavoriteView()
        case .add:
            EmptyView()
        case .chat:
            ChatsView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel(authService: MockAuthService()))
        .environmentObject(UserPropertyService())
}
