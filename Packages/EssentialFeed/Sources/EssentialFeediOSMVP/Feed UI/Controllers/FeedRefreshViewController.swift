//
//  FeedRefreshViewController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let presenter: FeedPresenter

    private(set) lazy var view = loadView()

    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

    @objc func refresh() {
        presenter.loadFeed()
    }

    func display(isLoading: Bool) {
        if isLoading {
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
