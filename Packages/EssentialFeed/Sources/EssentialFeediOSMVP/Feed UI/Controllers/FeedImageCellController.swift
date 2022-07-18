//
//  FeedImageCellController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

final class FeedImageCellController: FeedImageView {

    typealias Image = UIImage

    private let presenter: FeedImagePresenter<FeedImageCellController, UIImage>

    private lazy var cell = FeedImageCell()

    init(presenter: FeedImagePresenter<FeedImageCellController, UIImage>) {
        self.presenter = presenter
    }

    func view() -> UITableViewCell {
        presenter.loadImageData()
        return cell
    }

    func preload() {
        presenter.loadImageData()
    }

    func cancelLoad() {
        presenter.cancelTask()
    }

    func display(_ viewModel: FeedImageViewModel<Image>) {
        cell.onRetry = presenter.loadImageData
        cell.feedImageView.image = viewModel.image
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.locationContainer.isHidden = !presenter.hasLocation
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry

        if viewModel.isLoading {
            cell.feedImageContainer.startShimmering()
        } else {
            cell.feedImageContainer.stopShimmering()
        }
    }
}
