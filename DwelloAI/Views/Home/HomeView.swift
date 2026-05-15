//
//  HomeView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var filters = HomeFilterState()
    @State private var activeFilterSheet: HomeFilterSheetType? = nil

    @State private var searchResults: [Property] = []
    @State private var showSearchResults = false

    @StateObject private var viewModel = PropertyListViewModel(
        propertyService: LocalPropertyService()
    )

    private let horizontalPadding: CGFloat = 15

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let pageWidth = safeDimension(geo.size.width)
                let contentWidth = safeDimension(pageWidth - horizontalPadding * 2)

                ZStack {
                    Color(.systemGray6)
                        .ignoresSafeArea()

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            headerSection(
                                pageWidth: pageWidth,
                                contentWidth: contentWidth
                            )

                            VStack(spacing: 0) {
                                HomeSearchCard(
                                    filters: $filters,
                                    onFilterTap: { sheetType in
                                        activeFilterSheet = sheetType
                                    },
                                    onSearchTap: {
                                        searchProperties()
                                    }
                                )
                                .frame(width: contentWidth)
                                .clipped()
                                .offset(y: -150)
                                .padding(.bottom, -150)

                                offerBanner(width: contentWidth)
                                    .padding(.top, 20)

                                hotDealsSection
                                    .frame(width: contentWidth)
                                    .padding(.top, 20)

                                Spacer(minLength: 120)
                            }
                            .frame(width: pageWidth)
                        }
                        .frame(width: pageWidth)
                    }
                    .frame(width: pageWidth)
                    .ignoresSafeArea(edges: .top)
                }
            }
            .onAppear {
                viewModel.loadProperties()
            }
            .sheet(item: $activeFilterSheet) { sheetType in
                FilterBottomSheet(
                    type: sheetType,
                    filters: $filters
                )
            }
            .navigationDestination(isPresented: $showSearchResults) {
                SearchResultsView(properties: searchResults)
            }
        }
    }

    private func safeDimension(_ value: CGFloat) -> CGFloat {
        guard value.isFinite, value > 1 else {
            return 1
        }

        return value
    }
}

private extension HomeView {
    func headerSection(pageWidth: CGFloat, contentWidth: CGFloat) -> some View {
        ZStack(alignment: .top) {
            Image("home-header")
                .resizable()
                .scaledToFill()
                .frame(width: pageWidth, height: 300)
                .clipped()
                .overlay(
                    Color("AccentColor")
                        .opacity(0.88)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 28,
                        bottomTrailingRadius: 28,
                        topTrailingRadius: 0
                    )
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Hello Bakdaulet!")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(.orange)
                    .lineLimit(1)

                Text("Find your dream Home")
                    .font(.custom("Poppins-SemiBold", size: 22))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: contentWidth, alignment: .leading)
            .padding(.top, 80)
        }
        .frame(width: pageWidth, height: 300)
    }
}

private extension HomeView {
    func offerBanner(width: CGFloat) -> some View {
        ZStack {
            Image("new-apartments")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: 150)
                .clipped()
                .overlay(
                    Color("AccentColor")
                        .opacity(0.78)
                )

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("New apartments")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("with special offers, mortgages,\nand flexible purchase options")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundStyle(.orange)
                        .lineSpacing(2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)
            .frame(width: width, height: 150)
        }
        .frame(width: width, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .clipped()
    }
}

private extension HomeView {
    var hotDealsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Hot deals in your city")
                .font(.custom("Poppins-SemiBold", size: 26))
                .foregroundStyle(.black.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)

            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)

            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.hotDeals) { property in
                        NavigationLink {
                            PropertyDetailView(property: property)
                        } label: {
                            PropertyDealCardView(property: property)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension HomeView {
    func searchProperties() {
        let result = viewModel.properties.filter { property in
            let matchesMode: Bool

            switch filters.selectedMode {
            case .buy:
                matchesMode = property.listingType == .sale
            case .rent:
                matchesMode = property.listingType == .rent
            }

            let matchesCity: Bool
            if let selectedCity = filters.selectedCity {
                matchesCity = property.city == selectedCity
            } else {
                matchesCity = true
            }

            let matchesPrice: Bool
            if let selectedMaxPrice = filters.selectedMaxPrice {
                matchesPrice = property.price <= selectedMaxPrice
            } else {
                matchesPrice = true
            }

            let matchesRooms: Bool
            if let selectedRooms = filters.selectedRooms {
                matchesRooms = property.rooms == selectedRooms
            } else {
                matchesRooms = true
            }

            let matchesArea: Bool
            if let selectedMinArea = filters.selectedMinArea {
                matchesArea = property.area >= selectedMinArea
            } else {
                matchesArea = true
            }

            let matchesPropertyType: Bool
            if let selectedPropertyType = filters.selectedPropertyType {
                matchesPropertyType =
                property.propertyType.rawValue.lowercased() ==
                selectedPropertyType.rawValue.lowercased()
            } else {
                matchesPropertyType = true
            }

            return matchesMode &&
            matchesCity &&
            matchesPrice &&
            matchesRooms &&
            matchesArea &&
            matchesPropertyType
        }

        searchResults = result
        showSearchResults = true
    }
}

#Preview {
    HomeView()
}
