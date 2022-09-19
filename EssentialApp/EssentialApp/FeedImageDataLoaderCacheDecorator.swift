//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Nicolò Pasini on 20/09/22.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {

    private let cache: FeedImageDataCache
    private let decoratee: FeedImageDataLoader

    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.cache = cache
        self.decoratee = decoratee
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { imageData in
                self?.cache.saveIgnoringResult(imageData, for: url)
                return imageData
            })
        }
    }
}

private extension FeedImageDataCache {

    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}
