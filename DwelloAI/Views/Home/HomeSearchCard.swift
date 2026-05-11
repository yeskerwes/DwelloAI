//
//  HomeSearchCard.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct HomeSearchCard: View {
    @Binding var filters: HomeFilterState

    var onFilterTap: (HomeFilterSheetType) -> Void
    var onSearchTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            modePicker

            VStack(spacing: 12) {
                filterButton(
                    icon: "mappin.circle",
                    title: filters.selectedCity ?? "Select region, City, Country",
                    height: 60,
                    iconSize: 24,
                    textSize: 15
                ) {
                    onFilterTap(.city)
                }

                HStack(spacing: 7) {
                    filterButton(
                        icon: "tag",
                        title: priceTitle,
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    ) {
                        onFilterTap(.price)
                    }

                    filterButton(
                        icon: "door.left.hand.open",
                        title: roomsTitle,
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    ) {
                        onFilterTap(.rooms)
                    }

                    filterButton(
                        icon: "square.dashed",
                        title: areaTitle,
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    ) {
                        onFilterTap(.area)
                    }
                }

                HStack(spacing: 7) {
                    filterButton(
                        icon: "building.2",
                        title: filters.selectedPropertyType?.title ?? "Property type",
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    ) {
                        onFilterTap(.propertyType)
                    }

                    Button {
                        onFilterTap(.propertyType)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 14, weight: .medium))

                            Text("Advanced filter")
                                .font(.custom("Poppins-Medium", size: 12))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    onSearchTap()
                } label: {
                    Text("Search")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .buttonStyle(.plain)
                .padding(.top, 14)
            }
            .padding(.horizontal, 15)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private extension HomeSearchCard {
    var modePicker: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                modeButton(.buy)
                modeButton(.rent)
            }
            .frame(height: 54)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(height: 1)

                    Rectangle()
                        .fill(Color("AccentColor"))
                        .frame(width: geo.size.width / 2, height: 2)
                        .offset(x: filters.selectedMode == .buy ? 0 : geo.size.width / 2)
                        .animation(.easeInOut(duration: 0.25), value: filters.selectedMode)
                }
            }
            .frame(height: 2)
        }
    }

    func modeButton(_ mode: ListingMode) -> some View {
        Button {
            filters.selectedMode = mode
            filters.selectedMaxPrice = nil
        } label: {
            Text(mode.title)
                .font(.custom("Poppins-Medium", size: 20))
                .foregroundStyle(filters.selectedMode == mode ? .black : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
        }
        .buttonStyle(.plain)
    }

    func filterButton(
        icon: String,
        title: String,
        height: CGFloat,
        iconSize: CGFloat,
        textSize: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundStyle(.gray)
                    .frame(width: 24)

                Text(title)
                    .font(.custom("Poppins-Medium", size: textSize))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    var priceTitle: String {
        guard let price = filters.selectedMaxPrice else {
            return "Price"
        }

        if price >= 1_000_000 {
            return "≤ \(price / 1_000_000)M ₸"
        } else {
            return "≤ \(price / 1_000)K ₸"
        }
    }

    var roomsTitle: String {
        guard let rooms = filters.selectedRooms else {
            return "Rooms"
        }

        return "\(rooms) rooms"
    }

    var areaTitle: String {
        guard let area = filters.selectedMinArea else {
            return "Square"
        }

        return "From \(Int(area)) m²"
    }
}
