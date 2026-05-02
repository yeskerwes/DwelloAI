//
//  AuthServiceProtocol.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 30.04.2026.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    
    func getCurrentUser() -> User?
    func login(email: String, password: String) -> AnyPublisher<User, Error>
    func register(fullName: String, email: String, password: String) -> AnyPublisher<User, Error>
    func logout()
}
