//
//  FeedViewAdapter.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import UIKit
import Foundation
import EssentialFeed

final class FeedViewAdapter: FeedView {

    private let imageLoader: FeedImageDataLoader
    private weak var controller: FeedViewController?

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init
            )
            return view
        }
    }
}
