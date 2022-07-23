//
//  FeedPresenter.swift
//  
//
//  Created by Nicolò Pasini on 18/07/22.
//

import EssentialFeed

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedLoadingView: AnyObject {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {

    static var title: String { "My Feed" }

    private let feedView: FeedView
    private let loadingView: FeedLoadingView

    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }

    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
