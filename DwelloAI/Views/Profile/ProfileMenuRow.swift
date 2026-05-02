//
//  ProfileMenuRow.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import SwiftUI

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 36, height: 36)
                .background(Color("AccentColor").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundStyle(.black.opacity(0.85))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.gray)
        }
        .padding()
        .frame(height: 62)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ProfileMenuRow(icon: "heart.fill", title: "Favorites")
        .padding()
        .background(Color(.systemGray6))
}
