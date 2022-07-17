//
//  FeedViewModel.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import EssentialFeed

final class FeedViewModel {

    typealias Observer<T> = (T) -> Void

    var onFeedLoad: Observer<[FeedImage]>?
    var onLoadingStateChange: Observer<Bool>?

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }

            self?.onLoadingStateChange?(false)
        }
    }
}
