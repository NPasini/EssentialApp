//
//  FeedRefreshViewController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

final class FeedRefreshViewController: NSObject {

    private let viewModel: FeedViewModel

    private(set) lazy var view = binded(UIRefreshControl())

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    @objc func refresh() {
        viewModel.loadFeed()
    }

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        // Binding ViewModel with View
        viewModel.onChange = { [weak view] viewModel in
            if viewModel.isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }

        // Binding View with ViewModel
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // We are keeping the tartge of the action as the ViewController, since, in order to be a target, the object needs to conform to NSObject and this is a UIKit details which we don't want to leak in the ViewModel. Using other frameworks like Combine we could have been able to bind directly

        return view
    }
}
