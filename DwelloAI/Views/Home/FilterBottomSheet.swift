//
//  FilterBottomSheet.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct FilterBottomSheet: View {
    let type: HomeFilterSheetType

    @Binding var filters: HomeFilterState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    content
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .presentationDetents([.height(sheetHeight)])
        .presentationDragIndicator(.visible)
    }
}

private extension FilterBottomSheet {
    var header: some View {
        HStack {
            Text(LocalizedStringKey(type.title))
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(.black)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 34, height: 34)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, 10)
    }

    @ViewBuilder
    var content: some View {
        switch type {
        case .city:
            optionButton(
                title: "All cities",
                isSelected: filters.selectedCity == nil
            ) {
                filters.selectedCity = nil
            }

            optionButton(
                title: "Almaty",
                isSelected: filters.selectedCity == "Almaty"
            ) {
                filters.selectedCity = "Almaty"
            }

            optionButton(
                title: "Astana",
                isSelected: filters.selectedCity == "Astana"
            ) {
                filters.selectedCity = "Astana"
            }

            optionButton(
                title: "Shymkent",
                isSelected: filters.selectedCity == "Shymkent"
            ) {
                filters.selectedCity = "Shymkent"
            }

        case .price:
            optionButton(
                title: "Any price",
                isSelected: filters.selectedMaxPrice == nil
            ) {
                filters.selectedMaxPrice = nil
            }

            if filters.selectedMode == .buy {
                priceButton(title: "Up to 30M ₸", value: 30_000_000)
                priceButton(title: "Up to 50M ₸", value: 50_000_000)
                priceButton(title: "Up to 80M ₸", value: 80_000_000)
                priceButton(title: "Up to 120M ₸", value: 120_000_000)
                priceButton(title: "Up to 200M ₸", value: 200_000_000)
            } else {
                priceButton(title: "Up to 300K ₸", value: 300_000)
                priceButton(title: "Up to 400K ₸", value: 400_000)
                priceButton(title: "Up to 500K ₸", value: 500_000)
                priceButton(title: "Up to 700K ₸", value: 700_000)
            }

        case .rooms:
            optionButton(
                title: "Any rooms",
                isSelected: filters.selectedRooms == nil
            ) {
                filters.selectedRooms = nil
            }

            ForEach(1...6, id: \.self) { room in
                optionButton(
                    title: String(format: NSLocalizedString("%d rooms", comment: ""), room),
                    isSelected: filters.selectedRooms == room
                ) {
                    filters.selectedRooms = room
                }
            }

        case .area:
            optionButton(
                title: "Any square",
                isSelected: filters.selectedMinArea == nil
            ) {
                filters.selectedMinArea = nil
            }

            areaButton(title: "From 40 m²", value: 40)
            areaButton(title: "From 60 m²", value: 60)
            areaButton(title: "From 80 m²", value: 80)
            areaButton(title: "From 120 m²", value: 120)
            areaButton(title: "From 160 m²", value: 160)

        case .propertyType:
            optionButton(
                title: "All types",
                isSelected: filters.selectedPropertyType == nil
            ) {
                filters.selectedPropertyType = nil
            }

            ForEach(PropertyTypeFilter.allCases) { type in
                optionButton(
                    title: type.title,
                    isSelected: filters.selectedPropertyType == type
                ) {
                    filters.selectedPropertyType = type
                }
            }
        }
    }

    func priceButton(title: String, value: Int) -> some View {
        optionButton(
            title: title,
            isSelected: filters.selectedMaxPrice == value
        ) {
            filters.selectedMaxPrice = value
        }
    }

    func areaButton(title: String, value: Double) -> some View {
        optionButton(
            title: title,
            isSelected: filters.selectedMinArea == value
        ) {
            filters.selectedMinArea = value
        }
    }

    func optionButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
            dismiss()
        } label: {
            HStack {
                Text(LocalizedStringKey(title))
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(.black)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color("AccentColor"))
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(
                isSelected
                ? Color("AccentColor").opacity(0.08)
                : Color(.systemGray6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    var sheetHeight: CGFloat {
        switch type {
        case .city:
            return 360
        case .price:
            return 470
        case .rooms:
            return 500
        case .area:
            return 460
        case .propertyType:
            return 360
        }
    }
}
