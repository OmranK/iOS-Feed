//
//  CacheFeedUseCaseTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/9/22.
//

import Foundation
import XCTest


class LocalFeedLoader {
    init(store: FeedStore) {
    
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}


class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
