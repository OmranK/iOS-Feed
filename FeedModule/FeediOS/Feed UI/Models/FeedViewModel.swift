//
//  FeedViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedModule

final class FeedViewModel {
    
    private let feedLoader: FeedLoader
    
    internal init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self)}
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    var onSucessfulLoad: (([FeedImage]) -> Void)?
    
    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onSucessfulLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
