//
//  LocalFeedImageDataLoader.swift
//  
//
//  Created by Nicolò Pasini on 01/08/22.
//

import Foundation

public final class LocalFeedImageDataLoader {

    private final class LoadImageDataTask: FeedImageDataLoaderTask {

        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    private let store: FeedImageDataStore

    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {

    public enum LoadError: Error {
        case failed
        case notFound
    }

    public typealias LoadResult = FeedImageDataLoader.Result

    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(LoadError.notFound)
                })
        }
        return task
    }
}

extension LocalFeedImageDataLoader {

    public enum SaveError: Error {
        case failed
    }

    public typealias SaveResult = Result<Void, SaveError>

    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            completion(result.mapError { _ in SaveError.failed })
        }
    }
}