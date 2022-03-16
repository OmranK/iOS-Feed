//
//  FeedLoadingPresentationAdapter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import FeedCoreModule
import FeedPresentationModule
import FeediOS
import Combine

final class FeedLoadingPresentationAdapter: FeedViewControllerDelegate {
    
    var presenter: FeedPresenter?
    
    // MARK: - Composition with Combine Framework + universal abstractions
    
    private let feedLoader: () -> FeedLoader.Publisher
    private var cancellable: Cancellable?
    init(feedLoader: @escaping () -> FeedLoader.Publisher) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        cancellable = feedLoader().sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        } receiveValue: { [weak self] feed in
            self?.presenter?.didFinishLoadingFeed(feed: feed)
        }
    }
    
    // MARK: - Composition with Design Patterns
    
//    private let feedLoader: FeedLoader
//    init(feedLoader: FeedLoader) {
//        self.feedLoader = feedLoader
//    }
//
//    func didRequestFeedRefresh() {
//        presenter?.didStartLoadingFeed()
//        feedLoader.load { [weak self] result in
//            switch result {
//            case let .success(feed):
//                self?.presenter?.didFinishLoadingFeed(feed: feed)
//            case let .failure(error):
//                self?.presenter?.didFinishLoadingFeed(with: error)
//            }
//        }
//    }
    
}
