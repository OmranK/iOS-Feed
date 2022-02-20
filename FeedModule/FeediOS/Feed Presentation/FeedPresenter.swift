//
//  FeedPresenter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/20/22.
//

import FeedModule


protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter{
    
    private let feedLoader: FeedLoader
    
    internal init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    weak var loadingView: FeedLoadingView?
    var feedView: FeedView?
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
