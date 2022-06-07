//
//  RemoteFeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 06/06/22.
//

import Foundation

public final class RemoteFeedLoader {

    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }

    public enum Result: Equatable {
        case failure(Error)
        case success([FeedItem])
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
