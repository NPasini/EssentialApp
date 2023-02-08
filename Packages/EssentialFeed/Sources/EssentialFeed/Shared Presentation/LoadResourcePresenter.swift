//
//  LoadResourcePresenter.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation
import iOSUtilities

public final class LoadResourcePresenter {
    
    public static var title: String { Localized.Feed.title }

    private let feedView: FeedView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView

    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(errorMessage: Localized.Feed.loadError))
    }
}
