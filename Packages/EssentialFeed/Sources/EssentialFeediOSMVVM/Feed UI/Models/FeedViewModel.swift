//
//  FeedViewModel.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import EssentialFeed

final class FeedViewModel {

    private enum State {
        case pending
        case loading
    }

    var onFeedLoad: (([FeedImage]) -> Void)?
    var onChange: ((FeedViewModel) -> Void)?

    var isLoading: Bool {
        switch state {
        case .loading: return true
        default: return false
        }
    }

    private let feedLoader: FeedLoader

    private var state: State = .pending {
        didSet { onChange?(self) }
    }

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        state = .loading
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }

            self?.state = .pending
        }
    }
}
