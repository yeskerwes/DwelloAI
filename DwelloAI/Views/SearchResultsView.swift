//
//  SearchResultsView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import SwiftUI

struct SearchResultsView: View {
    let properties: [Property]
    var query: String? = nil

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            if properties.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 42, weight: .medium))
                        .foregroundStyle(.gray)

                    Text("No properties found")
                        .font(.custom("Poppins-SemiBold", size: 22))
                        .foregroundStyle(.black.opacity(0.85))

                    Text("Try changing your filters")
                        .font(.custom("Poppins-Regular", size: 15))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 24)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(properties) { property in
                            NavigationLink {
                                PropertyDetailView(property: property)
                            } label: {
                                PropertyDealCardView(property: property)
                                    .padding(.horizontal, 15)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .navigationTitle("Search results")
        .navigationBarTitleDisplayMode(.inline)
    }
}
