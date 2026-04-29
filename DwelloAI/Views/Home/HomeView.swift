//
//  HomeView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedMode: ListingMode = .buy
    @StateObject private var viewModel = PropertyListViewModel(
        propertyService: LocalPropertyService()
    )
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    
                    searchCard
                        .offset(y: -38)
                        .padding(.horizontal, 15)
                        .padding(.bottom, -10)
                    
                    offerBanner
                        .padding(.horizontal, 15)
                        .padding(.top, 8)
                    
                    hotDealsSection
                        .padding(.top, 26)
                    
                    Spacer(minLength: 120)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            viewModel.loadProperties()
        }
    }
}

// MARK: - Header

private extension HomeView {
    var headerSection: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Image("home-header")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: 330)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color("AccentColor").opacity(0.92),
                                Color("AccentColor").opacity(0.82),
                                Color("AccentColor").opacity(0.65)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello Bakdaulet!")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundStyle(Color.orange)
                    
                    Text("Find your dream Home")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 78)
            }
            .frame(width: geo.size.width, height: 330)
        }
        .frame(height: 330)
    }
}

// MARK: - Search Card

private extension HomeView {
    var searchCard: some View {
        VStack(spacing: 0) {
            modePicker
            
            VStack(spacing: 14) {
                filterField(
                    icon: "mappin.circle",
                    title: "Select region, City, Country"
                )
                
                HStack(spacing: 10) {
                    filterField(icon: "tag", title: "Price")
                    filterField(icon: "door.left.hand.open", title: "Rooms")
                    filterField(icon: "square.dashed", title: "Square")
                }
                
                HStack(spacing: 10) {
                    filterField(icon: "building.2", title: "Apartments")
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Advanced filter")
                                .font(.custom("Poppins-Medium", size: 12))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                
                Button {
                    
                } label: {
                    Text("Search")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.orange.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                .padding(.top, 18)
            }
            .padding(.horizontal, 16)
            .padding(.top, 26)
            .padding(.bottom, 28)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 34))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
    
    var modePicker: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                modeButton(.buy)
                modeButton(.rent)
            }
            .frame(height: 60)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(height: 1.5)
                    
                    Rectangle()
                        .fill(Color("AccentColor"))
                        .frame(width: geo.size.width / 2, height: 3)
                        .offset(x: selectedMode == .buy ? 0 : geo.size.width / 2)
                        .animation(.easeInOut(duration: 0.25), value: selectedMode)
                }
            }
            .frame(height: 3)
        }
    }
    
    func modeButton(_ mode: ListingMode) -> some View {
        Button {
            selectedMode = mode
        } label: {
            Text(mode.title)
                .font(.custom("Poppins-Medium", size: 16))
                .foregroundStyle(.black.opacity(0.85))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
    }
    
    func filterField(icon: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.gray)
                .frame(width: 24)
            
            Text(title)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundStyle(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Offer Banner

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
                .padding(.horizontal, 18)
            }
            .frame(width: geo.size.width, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .frame(height: 150)
    }
}

// MARK: - Hot Deals

private extension HomeView {
    var hotDealsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Hot deals in your city")
                .font(.custom("Poppins-SemiBold", size: 26))
                .foregroundStyle(.black.opacity(0.85))
                .padding(.horizontal, 15)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 15)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.hotDeals) { property in
                        PropertyDealCardView(property: property)
                            .padding(.horizontal, 15)
                    }
                }
            }
        }
    }
}

enum ListingMode {
    case buy
    case rent
    
    var title: String {
        switch self {
        case .buy:
            return "Buy"
        case .rent:
            return "Rent"
        }
    }
}

#Preview {
    HomeView()
}
