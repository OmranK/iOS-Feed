//
//  LocalImageLoaderTests.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import XCTest
import FeedCoreModule

protocol ImageDataStore {
     func retrieve(dataForURL url: URL)
}

final class LocalImageLoader {
    private struct Task: ImageLoaderTask {
        func cancel() {}
    }
    
    private let store: ImageDataStore
    
    init(store: ImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        store.retrieve(dataForURL: url)
        return Task()
    }
}

class LocalImageLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalImageLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy: ImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        private(set) var receivedMessages = [Message]()
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
    
}
