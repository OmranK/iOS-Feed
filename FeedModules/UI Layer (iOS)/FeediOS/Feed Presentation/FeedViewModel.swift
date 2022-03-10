//
//  FeedViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/20/22.
//

import FeedCoreModule

struct FeedViewModel {
    internal init(feed: [FeedImage]) {
        self.feed = feed
    }
    
    let feed: [FeedImage]
}
