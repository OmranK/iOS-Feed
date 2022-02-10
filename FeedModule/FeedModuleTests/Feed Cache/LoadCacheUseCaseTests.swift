//
//  LoadFeedFromCacheUseCaseTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/9/22.
//

import XCTest
import FeedModule

class LoadCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageTheStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
        
        enum ReceivedMessage: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        
        private(set) var receivedMessages = [ReceivedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            receivedMessages.append(.deleteCachedFeed)
            deletionCompletions.append(completion)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSucessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            receivedMessages.append(.insert(feed, timestamp))
            insertCompletions.append(completion)
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertCompletions[index](error)
        }
        
        func completeInsertionSucessfully(at index: Int = 0) {
            insertCompletions[index](nil)
        }
    }
}
