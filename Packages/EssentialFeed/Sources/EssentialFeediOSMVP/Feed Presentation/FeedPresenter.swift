//
//  FeedPresenter.swift
//  
//
//  Created by Nicolò Pasini on 18/07/22.
//

import Foundation
import iOSUtilities
import EssentialFeed

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

protocol FeedLoadingView: AnyObject {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {

    static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                    tableName: "Feed",
                    bundle: iOSUtilitiesPackageBundle,
                    comment: "Title for the feed view")
    }

    private let feedView: FeedView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView

    init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel(errorMessage: nil))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(errorMessage: Localized.Feed.loadError))
    }
}
