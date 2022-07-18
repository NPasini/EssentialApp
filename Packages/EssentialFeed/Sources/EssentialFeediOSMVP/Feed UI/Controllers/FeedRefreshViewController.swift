//
//  FeedRefreshViewController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let loadFeed: (() -> Void)

    private(set) lazy var view = loadView()

    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }

    @objc func refresh() {
        loadFeed()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
