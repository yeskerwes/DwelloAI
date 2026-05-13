//
//  MyListingsView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 11.05.2026.
//

import SwiftUI

struct MyListingsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var userPropertyService: UserPropertyService

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            if userPropertyService.userProperties.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .navigationTitle("My Listings")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let id = authViewModel.currentUser?.id {
                userPropertyService.load(for: id)
            }
        }
    }

    private var listContent: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(userPropertyService.userProperties) { property in
                    MyListingCard(property: property, onDelete: { delete(property) })
                        .padding(.horizontal, 15)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 120)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "house.circle")
                .font(.system(size: 72, weight: .regular))
                .foregroundStyle(Color("AccentColor"))
            Text("No listings yet")
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundStyle(.black.opacity(0.88))
            Text("Tap the + button to publish your first listing.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
            Spacer(minLength: 100)
        }
    }

    private func delete(_ property: Property) {
        guard let id = authViewModel.currentUser?.id else { return }
        userPropertyService.remove(property, for: id)
    }
}

private struct MyListingCard: View {
    let property: Property
    let onDelete: () -> Void

    @State private var showDeleteConfirm = false

    private let accentColor = Color("AccentColor")

    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink {
                PropertyDetailView(property: property)
            } label: {
                cardContent
            }
            .buttonStyle(.plain)

            deleteButton
                .padding(.top, 16)
                .padding(.trailing, 16)
        }
        .confirmationDialog("Delete this listing?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { onDelete() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var cardContent: some View {
        HStack(spacing: 14) {
            propertyImage

            VStack(alignment: .leading, spacing: 0) {
                Text(formattedPrice)
                    .font(.custom("Poppins-Medium", size: 22))
                    .foregroundStyle(accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.trailing, 44)

                Text("\(property.rooms)-room \(property.propertyType.rawValue) \(Int(property.area))m²,\nfloor \(property.floor)/\(property.totalFloors)")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.black.opacity(0.85))
                    .lineLimit(2)
                    .padding(.top, 8)

                Text("\(property.city), \(property.address)")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .padding(.top, 2)

                Spacer()

                HStack(spacing: 12) {
                    Text(property.listingType == .sale ? "For Sale" : "For Rent")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(.gray)

                    HStack(spacing: 5) {
                        Image(systemName: "eye")
                            .font(.system(size: 12))
                        Text("0")
                            .font(.custom("Poppins-Regular", size: 12))
                    }
                    .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 16)
        }
        .padding(14)
        .frame(height: 190)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var propertyImage: some View {
        ZStack(alignment: .bottomTrailing) {
            PropertyImageView(imageName: property.imageName)
                .frame(width: 165, height: 160)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing: 5) {
                Capsule()
                    .fill(accentColor)
                    .frame(width: 22, height: 5)
                Circle()
                    .fill(Color.white)
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(Color.white)
                    .frame(width: 6, height: 6)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 10)
        }
    }

    private var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.red)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return (formatter.string(from: NSNumber(value: property.price)) ?? "\(property.price)") + " ₸"
    }
}
