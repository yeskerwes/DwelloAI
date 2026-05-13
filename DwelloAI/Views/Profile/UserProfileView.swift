//
//  UserProfileView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject private var userPropertyService: UserPropertyService

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                profileHeader

                VStack(spacing: 12) {
                    NavigationLink {
                        MyListingsView()
                    } label: {
                        ProfileMenuRow(
                            icon: "house.fill",
                            title: "My Listings",
                            badge: userPropertyService.userProperties.isEmpty ? nil : "\(userPropertyService.userProperties.count)"
                        )
                    }
                    .buttonStyle(.plain)

                    ProfileMenuRow(icon: "heart.fill", title: "Favorites")
                    ProfileMenuRow(icon: "bell.fill", title: "Notifications")

                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        ProfileMenuRow(icon: "paintbrush.fill", title: "Appearance")
                    }
                    .buttonStyle(.plain)

                    ProfileMenuRow(icon: "questionmark.circle.fill", title: "Help Center")
                }

                Button {
                    authViewModel.logout()
                } label: {
                    Text("Log Out")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.red.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 8)

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
        }
        .background(Color(.systemGray6))
        .onAppear {
            if let id = authViewModel.currentUser?.id {
                userPropertyService.load(for: id)
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 86))
                .foregroundStyle(Color("AccentColor"))

            VStack(spacing: 4) {
                Text(authViewModel.currentUser?.fullName ?? "DwelloAI User")
                    .font(.custom("Poppins-SemiBold", size: 22))

                Text(authViewModel.currentUser?.email ?? "user@example.com")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
