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
    
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let mapper: Mapper
    private let resourceView: View
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView

    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping Mapper) {
        self.mapper = mapper
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
    }

    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView) where Resource == View.ResourceViewModel {
        self.mapper = { $0 }
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }

    public func didFinishLoading(with error: Error) {
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
        errorView.display(ResourceErrorViewModel(errorMessage: Localized.Shared.loadError))
    }
}
