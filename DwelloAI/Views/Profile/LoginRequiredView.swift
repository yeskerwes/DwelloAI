//
//  LoginRequiredView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import SwiftUI

struct LoginRequiredView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 80))
                .foregroundStyle(Color("AccentColor"))
            
            VStack(spacing: 8) {
                Text("You are not logged in")
                    .font(.custom("Poppins-SemiBold", size: 24))
                
                Text("Log in to save favorite properties, publish your own listings, and use the AI assistant.")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            NavigationLink {
                LoginView(authViewModel: authViewModel)
            } label: {
                Text("Log In")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color("AccentColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            
            NavigationLink {
                RegisterView(authViewModel: authViewModel)
            } label: {
                Text("Create Account")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(Color("AccentColor"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color("AccentColor").opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            
            Spacer()
            Spacer(minLength: 90)
        }
        .background(Color(.systemGray6))
    }
}
