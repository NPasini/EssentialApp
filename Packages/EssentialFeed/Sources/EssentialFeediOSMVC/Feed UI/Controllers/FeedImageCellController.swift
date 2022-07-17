//
//  FeedImageCellController.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {

    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader

    private var task: FeedImageDataLoaderTask?

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.locationContainer.isHidden = model.location == nil
        cell.feedImageContainer.startShimmering()

        let loadImage = { [weak self] in
            guard let self = self else { return }

            self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak cell] result in
                let imageData = try? result.get()
                let image = imageData.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = image != nil
                cell?.feedImageContainer.stopShimmering()
            }
        }

        cell.onRetry = loadImage
        loadImage()

        return cell
    }

    func preload() {
        task = self.imageLoader.loadImageData(from: self.model.url) { _ in }
    }

    func cancelLoad() {
        task?.cancel()
    }
}
