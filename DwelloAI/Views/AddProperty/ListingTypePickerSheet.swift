//
//  ListingTypePickerSheet.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 11.05.2026.
//

import SwiftUI

struct ListingTypePickerSheet: View {
    var onSelect: (ListingType) -> Void

    private let accent = Color("AccentColor")

    var body: some View {
        VStack(spacing: 0) {
            Text("What do you want to add?")
                .font(.custom("Poppins-SemiBold", size: 18))
                .padding(.top, 24)
                .padding(.bottom, 20)

            HStack(spacing: 14) {
                typeButton(
                    icon: "tag.fill",
                    title: "For Sale",
                    subtitle: "Sell your property",
                    type: .sale
                )

                typeButton(
                    icon: "key.fill",
                    title: "For Rent",
                    subtitle: "Rent out your property",
                    type: .rent
                )
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6).ignoresSafeArea())
    }

    private func typeButton(icon: String, title: LocalizedStringKey, subtitle: LocalizedStringKey, type: ListingType) -> some View {
        Button {
            onSelect(type)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.12))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(accent)
                }

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundStyle(.black.opacity(0.85))

                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
