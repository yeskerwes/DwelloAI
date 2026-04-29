//
//  LocalPropertyService.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 29.04.2026.
//

import Foundation
import Combine

final class LocalPropertyService: PropertyServiceProtocol {
    func fetchProperties() -> AnyPublisher<[Property], Error> {
        Future<[Property], Error> { promise in
            guard let url = Bundle.main.url(forResource: "properties", withExtension: "json") else {
                promise(.failure(NSError(
                    domain: "LocalPropertyService",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "properties.json not found"]
                )))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let properties = try JSONDecoder().decode([Property].self, from: data)
                promise(.success(properties))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
