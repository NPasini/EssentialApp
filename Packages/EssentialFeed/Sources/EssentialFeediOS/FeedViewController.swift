//
//  FeedViewController.swift
//  
//
//  Created by Nicolò Pasini on 11/07/22.
//

import UIKit
import EssentialFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}

public final class FeedViewController: UITableViewController {

    private var feedLoader: FeedLoader?
    private var tableModel = [FeedImage]()
    private var imageLoader: FeedImageDataLoader?
    private var imageDataTasks = [IndexPath: FeedImageDataLoaderTask]()

    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }

            self?.refreshControl?.endRefreshing()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        cell.locationContainer.isHidden = cellModel.location == nil
        cell.feedImageContainer.startShimmering()

        let loadImage = { [weak self] in
            guard let self = self else { return }

            self.imageDataTasks[indexPath] = self.imageLoader?.loadImageData(from: cellModel.url) { [weak cell] result in
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

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageDataTasks[indexPath]?.cancel()
        imageDataTasks[indexPath] = nil
    }
}
