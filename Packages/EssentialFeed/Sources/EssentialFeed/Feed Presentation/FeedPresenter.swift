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

public final class FeedPresenter {

    public static var title: String { Localized.Feed.title }

    private let feedView: FeedView
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView

    public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
        self.feedView = feedView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(Self.map(feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
        errorView.display(ResourceErrorViewModel(errorMessage: Localized.Shared.loadError))
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
