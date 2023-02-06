//
//  RemoteImageCommentsLoader.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import Foundation

public final class RemoteImageCommentsLoader: FeedLoader {

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
                completion(RemoteImageCommentsLoader.map(data, from: response))
            case .failure:
                completion(.failure(APIError.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {

    func toModels() -> [FeedImage] {
        map { FeedImage(id: $0.id, url: $0.image, location: $0.location, description: $0.description) }
    }
}
