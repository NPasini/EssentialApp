//
//  FeedUIComposer.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import Foundation
import EssentialFeed

public enum FeedUIComposer {

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map { FeedImageCellController(model: $0, imageLoader: imageLoader) }
        }

        return feedController
    }
}
