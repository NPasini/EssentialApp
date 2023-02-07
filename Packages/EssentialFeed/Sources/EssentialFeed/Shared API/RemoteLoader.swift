//
//  RemoteLoader.swift
//  
//
//  Created by nicolo.pasini on 07/02/23.
//

import Foundation

public final class RemoteLoader: FeedLoader {

    private let url: URL
    private let client: HTTPClient

    public typealias Result = FeedLoader.Result

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                completion(RemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(APIError.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
