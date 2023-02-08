//
//  FeedImagePresenter.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public protocol FeedImageView: AnyObject {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {

    private let view: View
    private let imageTransformer: (Data) -> Image?

    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    public func didStartLoadingImageData(for model: FeedImage) {
        let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: true, location: model.location, shouldRetry: false, description: model.description)
        view.display(viewModel)
    }

    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        let image = imageTransformer(data)
        let viewModel = FeedImageViewModel(image: image, isLoading: false, location: model.location, shouldRetry: image == nil, description: model.description)
        view.display(viewModel)
    }

    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: false, location: model.location, shouldRetry: true, description: model.description)
        view.display(viewModel)
    }
    
    public static func map(_ image: FeedImage) -> FeedImageViewModel<Image> {
        FeedImageViewModel(image: nil, isLoading: false, location: image.location, shouldRetry: false, description: image.description)
    }
}
