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

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
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
                            .offset(y: -150)
                            .padding(.bottom, -150)

                            offerBanner
                                .padding(.top, 20)

                            hotDealsSection
                                .padding(.top, 20)

                            Spacer(minLength: 120)
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .ignoresSafeArea(edges: .top)
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
}

private extension HomeView {
    var headerSection: some View {
        ZStack(alignment: .topLeading) {
            Image("home-header")
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
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

                Text("Find your dream Home")
                    .font(.custom("Poppins-SemiBold", size: 22))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, 15)
            .padding(.top, 80)
        }
        .frame(height: 300)
    }
}

private extension HomeView {
    var offerBanner: some View {
        GeometryReader { geo in
            ZStack {
                Image("new-apartments")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: 150)
                    .clipped()
                    .overlay(
                        Color("AccentColor")
                            .opacity(0.78)
                    )

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("New apartments")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text("with special offers, mortgages,\nand flexible purchase options")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundStyle(Color.orange)
                            .lineSpacing(2)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 15)
            }
            .frame(width: geo.size.width, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .frame(height: 150)
    }
}

private extension HomeView {
    var hotDealsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Hot deals in your city")
                .font(.custom("Poppins-SemiBold", size: 26))
                .foregroundStyle(.black.opacity(0.85))

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.red)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.hotDeals) { property in
                        NavigationLink {
                            PropertyDetailView(property: property)
                        } label: {
                            PropertyDealCardView(property: property)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
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
