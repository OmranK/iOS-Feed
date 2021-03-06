//
//  FeedStoreSpy.swift
//  FeedCoreModuleTests
//
//  Created by Omran Khoja on 2/9/22.
//

import Foundation
import FeedCoreModule

internal class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertCompletions = [InsertionCompletion]()
    private var retrieveCompletions = [RetrievalCompletion]()
    
    internal func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCachedFeed)
        deletionCompletions.append(completion)
    }
    
    internal func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    internal func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    internal func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(feed, timestamp))
        insertCompletions.append(completion)
    }
    
    internal func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](.failure(error))
    }
    
    internal func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletions[index](.success(()))
    }
    
    internal func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        retrieveCompletions.append(completion)
    }
    
    internal func completeRetrieval(with error: Error, at index: Int = 0) {
        retrieveCompletions[index](.failure(error))
    }
    
    internal func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrieveCompletions[index](.success(.none))
    }
    
    internal func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrieveCompletions[index](.success(CachedFeed(feed: feed, timestamp: timestamp)))
    }
}
