//
//  ListViewController+TestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import EssentialFeediOSMVP

extension ListViewController {
    
    var errorMessage: String? {
        errorView.message
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

extension ListViewController {
    
    var feedImagesSection: Int { 0 }
    var feedLoadMoreSection: Int { 1 }
    
    var canLoadMoreFeed: Bool {
        loadMoreFeedCell() != nil
    }
    
    var isShowingLoadMoreIndicator: Bool {
        loadMoreFeedCell()?.isLoading == true
    }
    
    var numberOfRenderedFeedImageViews: Int {
        numberOfRows(in: feedImagesSection)
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        cell(row: row, section: feedImagesSection)
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at row: Int) -> FeedImageCell? {
        feedImageView(at: row) as? FeedImageCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let dl = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        dl?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }
    
    func simulateFeedImageViewNearVisible(at row: Int = 0) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int = 0) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    @discardableResult
    func simulateFeedImageBecomingVisibleAgain(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewNotVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, willDisplay: view!, forRowAt: index)
        
        return view
    }
    
    func simulateTapOnLoadMoreFeedError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateLoadMoreFeedAction(tableView: UITableView? = nil) {
        // Loading when the cell becomes visible
        guard let view = loadMoreFeedCell() else { return }
        
        let dl = self.tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        dl?.tableView?(tableView ?? self.tableView, willDisplay: view, forRowAt: index)
    }

    func simulateScrollOnLoadMoreView(tableView: UITableView) {
        tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
    }
    
    func loadTestDoubleTableView(_ testTableView: UITableView) {
        testTableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        tableView = testTableView
        viewDidLoad()
    }
    
    private func loadMoreFeedCell() -> LoadMoreCell? {
        cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
    }
}

extension ListViewController {
    
    var imageCommentsSection: Int { 0 }
    
    var numberOfRenderedComments: Int {
        numberOfRows(in: imageCommentsSection)
    }
    
    var loadMoreFeedErrorMessage: String? {
        loadMoreFeedCell()?.message
    }
    
    func commentMessage(at row: Int) -> String? {
        commentView(at: row)?.messageLabel.text
    }
    
    func commentDate(at row: Int) -> String? {
        commentView(at: row)?.dateLabel.text
    }
    
    func commentUsername(at row: Int) -> String? {
        commentView(at: row)?.usernameLabel.text
    }
    
    private func commentView(at row: Int) -> ImageCommentCell? {
        cell(row: row, section: imageCommentsSection) as? ImageCommentCell
    }
}
