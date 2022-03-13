//
//  FeedLoaderCacheDecorator.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import XCTest
import FeedCoreModule
import FeedApplication

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
    
    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let cache = FeedCacheSpy()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [.save(feed)])
    }
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = FeedCacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [])
    }

    // MARK: - Helpers
    
    private func makeSUT(loaderResult: FeedLoader.Result, cache: FeedCacheSpy = FeedCacheSpy(), file: StaticString = #file, line: UInt = #line) -> FeedLoaderCacheDecorator {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    // MARK: - Spy
    private class FeedCacheSpy: FeedCache {
        private(set) var messages = [Message]()
        enum Message: Equatable {
            case save([FeedImage])
        }
        
        func save(_ feed: [FeedImage], completion: @escaping (FeedCache.Result) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }
    
}
