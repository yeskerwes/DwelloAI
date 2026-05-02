//
//  PropertyDealCardView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 29.04.2026.
//

import SwiftUI

struct PropertyDealCardView: View {
    let property: Property
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var isFavorite: Bool = false
    @State private var showLoginAlert: Bool = false
    
    private let accentColor = Color("AccentColor")
    private let favoritesService = LocalFavoritesService()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink {
                PropertyDetailView(property: property)
            } label: {
                cardContent
            }
            .buttonStyle(.plain)
            
            favoriteButton
                .padding(.top, 16)
                .padding(.trailing, 16)
        }
        .alert("Authorization Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Go to Profile") { }
        } message: {
            Text("Please log in to add this property to your favorites.")
        }
        .onAppear {
            isFavorite = favoritesService.isFavorite(propertyID: property.id)
        }
        .onReceive(NotificationCenter.default.publisher(for: .favoritesChanged)) { _ in
            isFavorite = favoritesService.isFavorite(propertyID: property.id)
        }
    }
}

private extension PropertyDealCardView {
    var cardContent: some View {
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
                        
                        Text("26")
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
    
    var propertyImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(property.imageName)
                .resizable()
                .scaledToFill()
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
    
    var favoriteButton: some View {
        Button {
            handleFavoriteTap()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(isFavorite ? .red : .gray)
                .frame(width: 36, height: 36)
                .background(
                    isFavorite
                    ? Color.red.opacity(0.08)
                    : Color.gray.opacity(0.08)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

private extension PropertyDealCardView {
    func handleFavoriteTap() {
        if isLoggedIn {
            favoritesService.toggleFavorite(propertyID: property.id)
            isFavorite = favoritesService.isFavorite(propertyID: property.id)
        } else {
            showLoginAlert = true
        }
    }
}

private extension PropertyDealCardView {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        
        let priceString = formatter.string(
            from: NSNumber(value: property.price)
        ) ?? "\(property.price)"
        
        return "\(priceString) ₸"
    }
}

#Preview {
    NavigationStack {
        PropertyDealCardView(
            property: Property(
                id: 1,
                title: "Modern Apartment in Almaty",
                city: "Almaty",
                address: "Abay Avenue 45",
                price: 42000000,
                propertyType: .apartment,
                listingType: .sale,
                rooms: 2,
                area: 58.5,
                floor: 7,
                totalFloors: 16,
                imageName: "property-1",
                description: "A modern 2-room apartment located near the city center.",
                latitude: 43.238949,
                longitude: 76.889709
            )
        )
        .padding()
        .background(Color(.systemGray6))
    }
}
