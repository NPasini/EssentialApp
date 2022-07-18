//
//  FeedImagePresenter.swift
//  
//
//  Created by Nicolò Pasini on 18/07/22.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    let image: Image?
    let isLoading: Bool
    let location: String?
    let shouldRetry: Bool
    let description: String?
}

protocol FeedImageView: AnyObject {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {

    weak var view: View?

    var location: String? {
        model.location
    }

    var description: String? {
        model.description
    }

    var hasLocation: Bool {
        location != nil
    }

    private let model: FeedImage
    private var task: FeedImageDataLoaderTask?
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?

    init(feed: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = feed
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    func loadImageData() {
        let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: true, location: model.location, shouldRetry: false, description: model.description)
        view?.display(viewModel)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    func cancelTask() {
        task?.cancel()
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            let viewModel = FeedImageViewModel(image: image, isLoading: false, location: model.location, shouldRetry: false, description: model.description)
            view?.display(viewModel)
        } else {
            let viewModel = FeedImageViewModel<Image>(image: nil, isLoading: false, location: model.location, shouldRetry: true, description: model.description)
            view?.display(viewModel)
        }
    }
}
