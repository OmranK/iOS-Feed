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
        
        wait(for: [expect], timeout: 1.0)    }
}
