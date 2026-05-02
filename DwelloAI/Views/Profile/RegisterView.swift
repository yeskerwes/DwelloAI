//
//  RegisterView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Create account")
                    .font(.custom("Poppins-SemiBold", size: 28))
                
                Text("Join DwelloAI and manage your property search easily.")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 14) {
                TextField("Full name", text: $fullName)
                    .padding()
                    .frame(height: 54)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
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
                
                SecureField("Confirm password", text: $confirmPassword)
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
                authViewModel.register(
                    fullName: fullName,
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
            } label: {
                Text("Create Account")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color("AccentColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 24)
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: authViewModel.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                dismiss()
            }
        }
    }
}
