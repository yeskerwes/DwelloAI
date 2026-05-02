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
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                        
                        searchCard
                            .offset(y: -150)
                            .padding(.horizontal, 15)
                            .padding(.bottom, -150)
                        
                        offerBanner
                            .padding(.horizontal, 15)
                            .padding(.top, 20)
                        
                        hotDealsSection
                            .padding(.top, 20)
                        
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
            .padding(.horizontal, 18)
            .padding(.top, 80)
        }
        .frame(height: 300)
    }
}

private extension HomeView {
    var searchCard: some View {
        VStack(spacing: 0) {
            modePicker
            
            VStack(spacing: 12) {
                filterField(
                    icon: "mappin.circle",
                    title: "Select region, City, Country",
                    height: 60,
                    iconSize: 24,
                    textSize: 15
                )
                
                HStack(spacing: 7) {
                    filterField(
                        icon: "tag",
                        title: "Price",
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    )
                    
                    filterField(
                        icon: "door.left.hand.open",
                        title: "Rooms",
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    )
                    
                    filterField(
                        icon: "square.dashed",
                        title: "Square",
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    )
                }
                
                HStack(spacing: 7) {
                    filterField(
                        icon: "building.2",
                        title: "Apartments",
                        height: 38,
                        iconSize: 16,
                        textSize: 14
                    )
                    
                    Button {
                        
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
                }
                
                Button {
                    
                } label: {
                    Text("Search")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
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
                        .offset(x: selectedMode == .buy ? 0 : geo.size.width / 2)
                        .animation(.easeInOut(duration: 0.25), value: selectedMode)
                }
            }
            .frame(height: 2)
        }
    }
    
    func modeButton(_ mode: ListingMode) -> some View {
        Button {
            selectedMode = mode
        } label: {
            Text(mode.title)
                .font(.custom("Poppins-Medium", size: 20))
                .foregroundStyle(.black.opacity(0.9))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
        }
    }
    
    func filterField(
        icon: String,
        title: String,
        height: CGFloat,
        iconSize: CGFloat,
        textSize: CGFloat
    ) -> some View {
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                .padding(.horizontal, 18)
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
