//
//  FeedMVPUIComposer.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import UIKit
import Foundation
import EssentialFeed

public enum FeedMVPUIComposer {

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        // In order to resolve circular dependencies we need to do property injection instead of constructor injection, the PresentationAdapter is a good candidate since is part of the composition
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(refreshController)
        )

        return feedController
    }
}

public final class WeakRefVirtualProxy<Object: AnyObject> {

    private weak var object: Object?

    init(_ object: Object) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where Object: FeedLoadingView {

    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where Object: FeedImageView, Object.Image == UIImage {
    typealias Image = UIImage

    func display(_ viewModel: FeedImageViewModel<Image>) {
        object?.display(viewModel)
    }
}

private final class FeedViewAdapter: FeedView {

    private let imageLoader: FeedImageDataLoader
    private weak var controller: FeedViewController?

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map {
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(feed: $0, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init
            )
            return view
        }
    }
}

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {

    var presenter: FeedPresenter?
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}

private final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {

    var presenter: FeedImagePresenter<View, Image>?

    private let model: FeedImage
    private var task: FeedImageDataLoaderTask?
    private let imageLoader: FeedImageDataLoader

    init(feed: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = feed
        self.imageLoader = imageLoader
    }

    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)

        let model = self.model
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }

    func didCancelImageRequest() {
        task?.cancel()
    }
}
