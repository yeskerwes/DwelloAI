//
//  ProfileView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isLoggedIn {
                    UserProfileView(authViewModel: authViewModel)
                } else {
                    LoginRequiredView(authViewModel: authViewModel)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel(authService: MockAuthService()))
}
