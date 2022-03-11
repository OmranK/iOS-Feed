//
//  ImageDataStoreSpy.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import Foundation
import FeedCoreModule

class ImageDataStoreSpy: ImageDataStore {
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    
    private var retrievalCompletions = [(ImageDataStore.RetrievalResult) -> Void]()
    private(set) var receivedMessages = [Message]()
    
    func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
}
