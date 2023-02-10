//
//  FeedEndpoint.swift
//  
//
//  Created by nicolo.pasini on 10/02/23.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
