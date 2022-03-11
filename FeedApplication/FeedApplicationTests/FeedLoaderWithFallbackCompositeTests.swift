//
//  FeedApplicationTests.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/11/22.
//

import XCTest
import FeedCoreModule

class FeedLoaderWithFallbackComposite {
    
    let primary: FeedLoader
    
    internal init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load(completion: completion)
    }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        let primaryLoader = LoaderStub(result: .success(primaryFeed))
        let fallbackLoader = LoaderStub(result: .success(fallbackFeed))
        
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryFeed)
            case .failure:
                XCTFail("Expected successful feed load result, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any description", location: "any location", url: URL(string: "http://any-url.com")!)]
    }
    
    // MARK: - Stub
    
    private class LoaderStub: FeedLoader {
        
        private let result: FeedLoader.Result
        
        internal init(result: FeedLoader.Result) {
            self.result = result
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(result)
        }
    }
}
 
