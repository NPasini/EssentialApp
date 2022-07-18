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

private final class FeedViewAdapter: FeedView {

    private let imageLoader: FeedImageDataLoader
    private weak var controller: FeedViewController?

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map {
            let feedImageViewModel = FeedImageViewModel(feed: $0, imageLoader: imageLoader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: feedImageViewModel)
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
