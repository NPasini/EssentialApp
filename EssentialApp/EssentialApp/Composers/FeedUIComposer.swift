//
//  FeedUIComposer.swift
//  
//
//  Created by Nicolò Pasini on 17/07/22.
//

import UIKit
import Combine
import iOSUtilities
import EssentialFeed
import EssentialFeediOSMVP

public enum FeedUIComposer {

    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) -> FeedViewController {
        // In order to resolve circular dependencies we need to do property injection instead of constructor injection, the PresentationAdapter is a good candidate since is part of the composition
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        
        let feedController = makeWith(
            title: FeedPresenter.title,
            delegate: presentationAdapter
        )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )

        return feedController
    }

    private static func makeWith(title: String, delegate: FeedViewControllerDelegate) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: EssentialFeediOSMVPPackageBundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.title = title
        feedController.delegate = delegate
        return feedController
    }
}
