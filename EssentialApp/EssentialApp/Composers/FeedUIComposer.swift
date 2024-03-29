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

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        // In order to resolve circular dependencies we need to do property injection instead of constructor injection, the PresentationAdapter is a good candidate since is part of the composition
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        
        let feedController = makeWith(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController)
        )

        return feedController
    }

    private static func makeWith(title: String) -> ListViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: EssentialFeediOSMVPPackageBundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
}
