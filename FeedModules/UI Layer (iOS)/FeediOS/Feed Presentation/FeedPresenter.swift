//
//  FeedPresenter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/20/22.
//

import Foundation
import FeedCoreModule

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedLoadingErrorView {
    func display(_ viewModel: FeedLoadingErrorViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter{
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let loadingErrorView: FeedLoadingErrorView
        
    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    init(feedView: FeedView, loadingView: FeedLoadingView, loadingErrorView: FeedLoadingErrorView) {
        self.loadingView = loadingView
        self.feedView = feedView
        self.loadingErrorView = loadingErrorView
    }

    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
        
    }
    
    func didFinishLoadingFeed(feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingErrorView.display(FeedLoadingErrorViewModel(errorMessage: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from server.")
    }
}
