//
//  FeedUIComposer.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import Foundation
import EssentialFeed
import EssentialFeediOSMVC

public enum FeedUIComposer {

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        FeedMVCUIComposer.feedComposedWith(feedLoader: feedLoader, imageLoader: imageLoader)
    }
}
