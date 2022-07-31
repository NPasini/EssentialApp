//
//  RemoteFeedImageDataLoader.swift
//  
//
//  Created by Nicolò Pasini on 31/07/22.
//

import Foundation

public final class RemoteFeedImageDataLoader {

    private final class HTTPTaskWrapper: FeedImageDataLoaderTask {

        var wrapped: HTTPClientTask?

        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    private let client: HTTPClient

    private static var isOK: Int { 200 }

    public init(client: HTTPClient) {
        self.client = client
    }

    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                task.complete(with: .failure(APIError.connectivity))
            case let .success((data, response)):
                if response.statusCode == RemoteFeedImageDataLoader.isOK, !data.isEmpty {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(APIError.invalidData))
                }
            }
        }

        return task
    }
}
