//
//  FeedPresenter.swift
//  
//
//  Created by Nicolò Pasini on 18/07/22.
//

import EssentialFeed

protocol FeedView {
    func display(feed: [FeedImage])
}

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

final class FeedPresenter {

    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }

            self?.loadingView?.display(isLoading: false)
        }
    }
}
