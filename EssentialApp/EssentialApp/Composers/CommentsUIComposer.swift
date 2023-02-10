//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by nicolo.pasini on 10/02/23.
//

import UIKit
import Combine
import iOSUtilities
import EssentialFeed
import EssentialFeediOSMVP

public enum CommentsUIComposer {

    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        // In order to resolve circular dependencies we need to do property injection instead of constructor injection, the PresentationAdapter is a good candidate since is part of the composition
        let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
        
        let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(controller: commentsController),
            loadingView: WeakRefVirtualProxy(commentsController),
            errorView: WeakRefVirtualProxy(commentsController),
            mapper: { ImageCommentsPresenter.map($0) }
        )

        return commentsController
    }

    private static func makeCommentsViewController(title: String) -> ListViewController {
        let storyboard = UIStoryboard(name: "ImageComments", bundle: EssentialFeediOSMVPPackageBundle)
        let commentsController = storyboard.instantiateInitialViewController() as! ListViewController
        commentsController.title = title
        return commentsController
    }
}
