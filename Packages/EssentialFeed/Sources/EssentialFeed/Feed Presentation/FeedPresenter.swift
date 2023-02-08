//
//  FeedPresenter.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation
import iOSUtilities

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class FeedPresenter {

    public static var title: String { Localized.Feed.title }

    private let feedView: FeedView
    private let errorView: FeedErrorView
    private let loadingView: ResourceLoadingView

    public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(errorMessage: Localized.Shared.loadError))
    }
}
