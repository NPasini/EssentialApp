//
//  WeakRefVirtualProxy.swift
//  
//
//  Created by Nicolò Pasini on 19/07/22.
//

import UIKit
import EssentialFeed

final class WeakRefVirtualProxy<Object: AnyObject> {

    private weak var object: Object?

    init(_ object: Object) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where Object: ResourceLoadingView {

    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedErrorView where Object: FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where Object: FeedImageView, Object.Image == UIImage {
    typealias Image = UIImage

    func display(_ viewModel: FeedImageViewModel<Image>) {
        object?.display(viewModel)
    }
}
