//
//  CodableFeedStoreTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import XCTest
import FeedModule

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [LocalFeedImage]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    
    func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.feed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        
        let encoder = JSONEncoder()
        let encodedData = try! encoder.encode(Cache(feed: feed, timestamp: timestamp))
        try! encodedData.write(to: storeURL)
        
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyCacheOnEmptyCache() {
        let sut = CodableFeedStore()
        let expect = expectation(description: "Wait for result")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Exepected empty result, returned \(result) instead")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let expect = expectation(description: "Wait for result")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Exepected retrieving twice from an empty cache to deliver same empty cache result, got \(firstResult) and \(secondResult) instead")
                }
                expect.fulfill()
            }
            }
        
        wait(for: [expect], timeout: 1.0)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = CodableFeedStore()
        let expect = expectation(description: "Wait for result")

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        sut.insert(feed, timestamp: timestamp) { error in
            XCTAssertNil(error, "Expected feed to be inserted successfully")

            sut.retrieve { result in
                switch result {
                case let .found(retrievedFeed, retrievedTimestamp):
                    XCTAssertEqual(feed, retrievedFeed)
                    XCTAssertEqual(timestamp, retrievedTimestamp)
                default:
                    XCTFail("Exepected found result with feed \(feed) and timestamp \(timestamp), got \(result) instead")
                }
                expect.fulfill()
            }

        }

        wait(for: [expect], timeout: 1.0)
    }
}
