//
//  FeedViewControllerTests.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/17/22.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {}
}


final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}

