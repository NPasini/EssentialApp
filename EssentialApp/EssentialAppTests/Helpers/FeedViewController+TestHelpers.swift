//
//  FeedViewController+TestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import EssentialFeediOSMVP

extension FeedViewController {

    var feedImageSection: Int { 0 }

    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }

    var numberOfRenderedFeedImageViews: Int {
        tableView.numberOfRows(inSection: feedImageSection)
    }

    var errorMessage: String? {
        errorView?.message
    }

    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews > row else {
            return nil
        }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImageSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    @discardableResult
    func simulateFeedImageViewVisible(at row: Int) -> FeedImageCell? {
        feedImageView(at: row) as? FeedImageCell
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let dl = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        dl?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }

    func simulateFeedImageViewNearVisible(at row: Int = 0) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int = 0) {
        simulateFeedImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func simulateUserTapOnErrorMessage() {
        errorView?.button.simulateTap()
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        simulateFeedImageViewVisible(at: index)?.renderedImage
    }
}