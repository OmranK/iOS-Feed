//
//  FeedLoaderCacheDecorator.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import FeedCoreModule
import XCTest

class FeedLoaderCacheDecorator: FeedLoader {
    
    let decoratee: FeedLoader
    
    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase  {
    
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_load_deliversErrorOnLoaderError() {
        let error = anyNSError()
        let sut = makeSUT(loaderResult: .failure(error))
        expect(sut, toCompleteWith: .failure(error))
    }

    // MARK: - Helpers
    
    private func makeSUT(loaderResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoaderCacheDecorator {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
}
