//
//  FeedImageViewModel.swift
//
//
//  Created by Nicolò Pasini on 17/07/22.
//

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {

    typealias Observer<T> = (T) -> Void

    var location: String? {
        model.location
    }

    var description: String? {
        model.description
    }

    var hasLocation: Bool {
        location != nil
    }

    var onImageLoaded: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?

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
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    func cancelTask() {
        task?.cancel()
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoaded?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }

        onImageLoadingStateChange?(false)
    }
}
