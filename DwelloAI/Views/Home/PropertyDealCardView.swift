//
//  PropertyDealCardView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 29.04.2026.
//

import SwiftUI

struct PropertyDealCardView: View {
    let property: Property
    
    private let accentColor = Color("AccentColor")
    
    var body: some View {
        HStack(spacing: 14) {
            propertyImage
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(formattedPrice)
                        .font(.custom("Poppins-Medium", size: 24))
                        .foregroundStyle(accentColor)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.gray)
                            .frame(width: 38, height: 38)
                            .background(Color.gray.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Text("\(property.rooms)-room \(property.propertyType.rawValue) \(Int(property.area))m²,\nfloor \(property.floor)/\(property.totalFloors)")
                    .font(.custom("Poppins-Regular", size: 17))
                    .foregroundStyle(.black.opacity(0.85))
                    .lineLimit(2)
                    .padding(.top, 8)
                
                Text("\(property.city), \(property.address)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .padding(.top, 2)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text("11 january")
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
    
    private var propertyImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(property.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 170, height: 160)
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
    
    private var formattedPrice: String {
        if property.listingType == .rent {
            return "\(property.price)$"
        } else {
            return "\(property.price)$"
        }
    }
}

#Preview {
    PropertyDealCardView(
        property: Property(
            id: 1,
            title: "Modern Apartment in Almaty",
            city: "Almaty",
            address: "Abay street 150a",
            price: 75000,
            propertyType: .apartment,
            listingType: .sale,
            rooms: 2,
            area: 85,
            floor: 7,
            totalFloors: 12,
            imageName: "property-1",
            description: "Modern apartment",
            latitude: 43.238949,
            longitude: 76.889709
        )
    )
}
