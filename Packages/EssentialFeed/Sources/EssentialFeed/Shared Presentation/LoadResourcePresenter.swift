//
//  LoadResourcePresenter.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation
import iOSUtilities

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private let mapper: Mapper
    private let resourceView: View
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView

    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.mapper = mapper
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(errorMessage: Localized.Feed.loadError))
    }
}
