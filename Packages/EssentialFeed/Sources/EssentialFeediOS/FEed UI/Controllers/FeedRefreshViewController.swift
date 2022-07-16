//
//  FeedRefreshViewController.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {

    var onRefresh: (([FeedImage]) -> Void)?

    private var feedLoader: FeedLoader

    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }

            self?.view.endRefreshing()
        }
    }
}
