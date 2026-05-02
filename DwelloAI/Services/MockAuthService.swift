//
//  MockAuthService.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import Foundation
import Combine

enum AuthError: LocalizedError {
    case emptyFields
    case invalidCredentials
    case passwordsDoNotMatch
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please fill in all fields."
        case .invalidCredentials:
            return "Invalid email or password."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        }
    }
}

final class MockAuthService: AuthServiceProtocol {
    private let isLoggedInKey = "isLoggedIn"
    private let currentUserKey = "currentUser"
    private let savedEmailKey = "savedEmail"
    private let savedPasswordKey = "savedPassword"
    
    var isLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func getCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            guard !email.isEmpty, !password.isEmpty else {
                promise(.failure(AuthError.emptyFields))
                return
            }
            
            let testEmail = "test@gmail.com"
            let testPassword = "123456"
            
            let savedEmail = UserDefaults.standard.string(forKey: self.savedEmailKey)
            let savedPassword = UserDefaults.standard.string(forKey: self.savedPasswordKey)
            
            let isTestAccount = email == testEmail && password == testPassword
            let isRegisteredAccount = email == savedEmail && password == savedPassword
            
            if isTestAccount || isRegisteredAccount {
                let user = User(
                    id: UUID(),
                    fullName: isTestAccount ? "Bakdaulet Yeskermes" : "DwelloAI User",
                    email: email,
                    phone: "+7 777 123 45 67",
                    avatarName: nil
                )
                
                self.saveUser(user)
                promise(.success(user))
            } else {
                promise(.failure(AuthError.invalidCredentials))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func register(fullName: String, email: String, password: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
                promise(.failure(AuthError.emptyFields))
                return
            }
            
            let user = User(
                id: UUID(),
                fullName: fullName,
                email: email,
                phone: nil,
                avatarName: nil
            )
            
            UserDefaults.standard.set(email, forKey: self.savedEmailKey)
            UserDefaults.standard.set(password, forKey: self.savedPasswordKey)
            
            self.saveUser(user)
            promise(.success(user))
        }
        .eraseToAnyPublisher()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    private func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        }
        
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
    }
}
