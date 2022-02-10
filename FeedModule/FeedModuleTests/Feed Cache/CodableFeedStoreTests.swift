//
//  CodableFeedStoreTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import XCTest
import FeedModule

class CodableFeedStore {
    
    func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
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
}
