//
//  FavoriteView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct FavoriteView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @StateObject private var authViewModel = AuthViewModel(
        authService: MockAuthService()
    )
    
    @StateObject private var viewModel = FavoritesViewModel(
        propertyService: LocalPropertyService(),
        favoritesService: LocalFavoritesService()
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                if isLoggedIn {
                    favoriteContent
                } else {
                    LoginRequiredView(authViewModel: authViewModel)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if isLoggedIn {
                    viewModel.loadFavorites()
                }
            }
            .onChange(of: isLoggedIn) { _, newValue in
                if newValue {
                    viewModel.loadFavorites()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .favoritesChanged)) { _ in
                if isLoggedIn {
                    viewModel.loadFavorites()
                }
            }
        }
    }
}

// MARK: - Content

private extension FavoriteView {
    var favoriteContent: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if viewModel.favoriteProperties.isEmpty {
                emptyFavoritesView
            } else {
                favoritesList
            }
        }
    }
    
    var favoritesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteProperties) { property in
                    FavoritePropertyCardView(
                        property: property,
                        onRemove: {
                            viewModel.removeFromFavorites(property)
                        }
                    )
                    .padding(.horizontal, 15)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 120)
        }
    }
    
    var emptyFavoritesView: some View {
        VStack(spacing: 18) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 72, weight: .regular))
                .foregroundStyle(Color("AccentColor"))
            
            Text("No favorites yet")
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundStyle(.black.opacity(0.88))
            
            Text("Properties you like will appear here. Tap the heart icon on any listing to save it.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            Spacer(minLength: 100)
        }
    }
    
    func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.red)
            
            Text(message)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}
