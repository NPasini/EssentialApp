//
//  FeedImagePresenter.swift
//  
//
//  Created by Nicolò Pasini on 18/07/22.
//

import Foundation
import EssentialFeed

protocol FeedImageView: AnyObject {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {

    private let view: View
    private let imageTransformer: (Data) -> Image?

    private struct InvalidImageDataError: Error {}

    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    func didStartLoadingImageData(for model: FeedImage) {
        let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: true, location: model.location, shouldRetry: false, description: model.description)
        view.display(viewModel)
    }

    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }

        let viewModel = FeedImageViewModel(image: image, isLoading: false, location: model.location, shouldRetry: false, description: model.description)
        view.display(viewModel)
    }

    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: false, location: model.location, shouldRetry: true, description: model.description)
        view.display(viewModel)
    }
}
