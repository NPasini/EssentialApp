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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)

        return feedController
    }
}

private final class FeedViewAdapter: FeedView {

    private let imageLoader: FeedImageDataLoader
    private weak var controller: FeedViewController?

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map {
            let feedImageViewModel = FeedImageViewModel(feed: $0, imageLoader: imageLoader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: feedImageViewModel)
        }
    }
}
