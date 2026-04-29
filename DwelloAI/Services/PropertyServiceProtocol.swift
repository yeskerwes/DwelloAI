//
//  PropertyServiceProtocol.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 28.04.2026.
//

import Combine

protocol PropertyServiceProtocol {
    func fetchProperties() -> AnyPublisher<[Property], Error>
}
