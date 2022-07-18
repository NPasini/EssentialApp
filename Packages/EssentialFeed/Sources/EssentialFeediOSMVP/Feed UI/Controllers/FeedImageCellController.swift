//
//  FeedImageCellController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {

    private lazy var cell = FeedImageCell()
    private let delegate: FeedImageCellControllerDelegate

    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }

    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }

    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        delegate.didCancelImageRequest()
    }

    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.onRetry = delegate.didRequestImage
        cell.feedImageView.image = viewModel.image
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry

        if viewModel.isLoading {
            cell.feedImageContainer.startShimmering()
        } else {
            cell.feedImageContainer.stopShimmering()
        }
    }
}
