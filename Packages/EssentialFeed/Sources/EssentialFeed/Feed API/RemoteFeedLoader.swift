//
//  RemoteFeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 06/06/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {

    private let url: URL
    private let client: HTTPClient

    public typealias Result = FeedLoadResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(APIError.connectivity))
            }
        }
    }
}
