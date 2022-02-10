//
//  FeedStoreSpy.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/9/22.
//

import Foundation
import FeedModule

internal class FeedStoreSpy: FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertCompletions = [InsertionCompletion]()
    
    internal func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCachedFeed)
        deletionCompletions.append(completion)
    }
    
    internal func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    internal func completeDeletionSucessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    internal func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(feed, timestamp))
        insertCompletions.append(completion)
    }
    
    internal func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](error)
    }
    
    internal func completeInsertionSucessfully(at index: Int = 0) {
        insertCompletions[index](nil)
    }
    
    internal func retrieve() {
        receivedMessages.append(.retrieve)
    }
    
    
}
