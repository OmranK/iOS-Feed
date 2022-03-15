//
//  FeedViewController+Helpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import FeediOS
import UIKit

extension FeedViewController {
    
    var errorMessage: String? {
        return errorView?.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateVisibleImageView(at: index)?.renderedImage
    }
    
    @discardableResult
    func simulateVisibleImageView(at index: Int) -> FeedImageCell? {
        return (feedImageView(at: index) as? FeedImageCell)!
    }
    
    @discardableResult
    func simulateNotVisibleImageView(at row: Int) -> FeedImageCell? {
        let view = feedImageView(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: 0)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return (view as! FeedImageCell)
    }
    
    func simulateImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateImageViewNotNearVisible(at row: Int) {
        simulateImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedImagesSection: Int {
        return 0
    }
}
