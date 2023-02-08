//
//  LoadResourcePresenter.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation
import iOSUtilities

public protocol ResourceView {
    func display(_ viewModel: String)
}

public final class LoadResourcePresenter {
    
    public typealias Mapper = (String) -> String
    
    private let mapper: Mapper
    private let errorView: FeedErrorView
    private let resourceView: ResourceView
    private let loadingView: FeedLoadingView

    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.mapper = mapper
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(errorMessage: Localized.Feed.loadError))
    }
}
