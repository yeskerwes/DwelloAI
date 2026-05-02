//
//  AuthViewModel.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        self.isLoggedIn = authService.isLoggedIn
        self.currentUser = authService.getCurrentUser()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
    
    func register(fullName: String, email: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            errorMessage = AuthError.passwordsDoNotMatch.localizedDescription
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        authService.register(fullName: fullName, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        authService.logout()
        currentUser = nil
        isLoggedIn = false
    }
}
