//
//  FeedEndpoint.swift
//  
//
//  Created by nicolo.pasini on 10/02/23.
//

import Foundation

public enum FeedEndpoint {
    case get(after: FeedImage? = nil)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(image):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10"),
                image.map { URLQueryItem(name: "after_id", value: $0.id.uuidString) }
            ].compactMap { $0 }
            return components.url! // Usiamo il force unwrap perché la base URL è statica, schiantata a codice, non può succedere che sia sbagliata
        }
    }
}
