//
//  PropertyDetailView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import SwiftUI

struct PropertyDetailView: View {
    let property: Property
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var isFavorite: Bool = false
    @State private var showLoginAlert: Bool = false
    
    private let accentColor = Color("AccentColor")
    private let favoritesService = LocalFavoritesService()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    imageSection
                    
                    VStack(alignment: .leading, spacing: 18) {
                        priceAndFavoriteSection
                        
                        titleSection
                        
                        propertyInfoSection
                        
                        descriptionSection
                        
                        locationSection
                    }
                    .padding(.horizontal, 15)
                    
                    Spacer(minLength: 120)
                }
            }
            
            contactButton
        }
        .navigationBarTitleDisplayMode(.inline)
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

private extension PropertyDetailView {
    var imageSection: some View {
        ZStack(alignment: .bottomLeading) {
            Image(property.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .frame(maxWidth: .infinity)
                .clipped()
            
            LinearGradient(
                colors: [
                    .black.opacity(0.0),
                    .black.opacity(0.55)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(property.listingType == .sale ? "For Sale" : "For Rent")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(accentColor)
                    .clipShape(Capsule())
                
                Text(property.propertyType.rawValue.capitalized)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
        }
//        .frame(height: 330)
    }
}

private extension PropertyDetailView {
    var priceAndFavoriteSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedPrice)
                    .font(.custom("Poppins-SemiBold", size: 28))
                    .foregroundStyle(accentColor)
                
                Text(property.listingType == .rent ? "per month" : "total price")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                handleFavoriteTap()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(isFavorite ? .red : .gray)
                    .frame(width: 52, height: 52)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 6)
    }
}

private extension PropertyDetailView {
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(property.title)
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundStyle(.black.opacity(0.88))
                .lineLimit(2)
            
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(accentColor)
                
                Text("\(property.city), \(property.address)")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private extension PropertyDetailView {
    var propertyInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Property details")
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(.black.opacity(0.88))
            
            HStack(spacing: 10) {
                detailBox(
                    icon: "bed.double.fill",
                    title: "Rooms",
                    value: "\(property.rooms)"
                )
                
                detailBox(
                    icon: "square.fill",
                    title: "Area",
                    value: "\(Int(property.area)) m²"
                )
                
                detailBox(
                    icon: "building.fill",
                    title: "Floor",
                    value: "\(property.floor)/\(property.totalFloors)"
                )
            }
        }
    }
    
    func detailBox(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(accentColor)
            
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundStyle(.black.opacity(0.85))
            
            Text(title)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 105)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private extension PropertyDetailView {
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(.black.opacity(0.88))
            
            Text(property.description)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(.gray)
                .lineSpacing(4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private extension PropertyDetailView {
    var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(.black.opacity(0.88))
            
            MapViewRepresentable(
                latitude: property.latitude,
                longitude: property.longitude,
                title: property.title
            )
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

private extension PropertyDetailView {
    var contactButton: some View {
        VStack {
            Button {
                
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Contact Agent")
                        .font(.custom("Poppins-Medium", size: 16))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal, 15)
            .padding(.top, 12)
            .padding(.bottom, 18)
        }
        .background(
            Color.white
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: -4)
        )
    }
}

private extension PropertyDetailView {
    func handleFavoriteTap() {
        if isLoggedIn {
            favoritesService.toggleFavorite(propertyID: property.id)
            isFavorite = favoritesService.isFavorite(propertyID: property.id)
        } else {
            showLoginAlert = true
        }
    }
}

private extension PropertyDetailView {
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
        PropertyDetailView(
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
                description: "A modern 2-room apartment located near the city center. Suitable for young families or students.",
                latitude: 43.238949,
                longitude: 76.889709
            )
        )
    }
}
