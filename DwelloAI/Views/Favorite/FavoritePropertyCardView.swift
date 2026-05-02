//
//  FavoritePropertyCardView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import SwiftUI

struct FavoritePropertyCardView: View {
    let property: Property
    let onRemove: () -> Void
    
    private let accentColor = Color("AccentColor")
    
    var body: some View {
        NavigationLink {
            PropertyDetailView(property: property)
        } label: {
            HStack(spacing: 14) {
                propertyImage
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Text(formattedPrice)
                            .font(.custom("Poppins-Medium", size: 22))
                            .foregroundStyle(accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Spacer()
                        
                        Button {
                            onRemove()
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.red)
                                .frame(width: 36, height: 36)
                                .background(Color.red.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                    
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
                    
                    Text(property.listingType == .sale ? "For Sale" : "For Rent")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 16)
            }
            .padding(14)
            .frame(height: 190)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
    
    private var propertyImage: some View {
        Image(property.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 165, height: 160)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var formattedPrice: String {
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
    FavoritePropertyCardView(
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
        ),
        onRemove: {}
    )
    .padding()
    .background(Color(.systemGray6))
}
