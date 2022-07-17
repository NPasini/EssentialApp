//
//  FeedUIComposer.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import Foundation
import EssentialFeed
import EssentialFeediOSMVVM

public enum FeedUIComposer {

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        FeedMVVMUIComposer.feedComposedWith(feedLoader: feedLoader, imageLoader: imageLoader)
    }
}
