//
//  FeedPresenter.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/9/22.
//

import Foundation
import FeedCoreModule

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewVM)
}

public protocol FeedLoadingErrorView {
    func display(_ viewModel: FeedLoadingErrorViewVM)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewVM)
}

public final class FeedPresenter {
    
    private let loadingView: FeedLoadingView
    private let errorView: FeedLoadingErrorView
    private let feedView: FeedView
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }

    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedLoadingErrorView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.feedView = feedView
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewVM(isLoading: true))
    }
    
    public func didFinishLoadingFeed(feed: [FeedImage]) {
        feedView.display(FeedViewVM(feed: feed))
        loadingView.display(FeedLoadingViewVM(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedLoadingErrorViewVM.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewVM(isLoading: false))
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from server.")
    }
}
