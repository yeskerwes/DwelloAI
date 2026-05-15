//
//  LoginView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome back")
                    .font(.custom("Poppins-SemiBold", size: 28))
                
                Text("Log in to continue using DwelloAI.")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 14) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .frame(height: 54)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(height: 54)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                authViewModel.login(email: email, password: password)
            } label: {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("Log In")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 24)
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: authViewModel.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                dismiss()
            }
        }
    }
}
