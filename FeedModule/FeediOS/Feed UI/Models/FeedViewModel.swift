//
//  FeedViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedModule

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    
    internal init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onSuccessfulLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onSuccessfulLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
