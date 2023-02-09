//
//  FeedImageCellController.swift
//
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import iOSUtilities
import EssentialFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: CellController, ResourceView, ResourceLoadingView, ResourceErrorView {
    
    public typealias ResourceViewModel = UIImage

    private var cell: FeedImageCell?
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate

    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
    }

    public func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.feedImageView.image = nil
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.onRetry = delegate.didRequestImage
        delegate.didRequestImage()
        return cell!
    }

    public func preload() {
        delegate.didRequestImage()
    }

    public func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: EssentialFeed.ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: EssentialFeed.ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.errorMessage == nil
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
