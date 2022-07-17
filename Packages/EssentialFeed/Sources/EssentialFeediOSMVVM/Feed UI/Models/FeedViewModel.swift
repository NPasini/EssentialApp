//
//  FeedViewModel.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import EssentialFeed

final class FeedViewModel {

    var onFeedLoad: (([FeedImage]) -> Void)?
    var onChange: ((FeedViewModel) -> Void)?

    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }

            self?.isLoading = false
        }
    }
}
