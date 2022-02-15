//
//  CoreDataFeedStoreTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import XCTest
import FeedModule

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyCacheOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    func test_insert_overridesExistingNonEmptyCache() {
        
    }
    
    func test_deleteCachedFeed_deliversNoErrorOnEmptyCache() {
        
    }
    
    func test_deleteCachedFeed_hasNoSideEffectsOnEmptyCache() {
        
    }
    
    func test_deleteCachedFeed_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    func test_deleteCachedFeed_deletesExistingNonEmptyCache() {
        
    }
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let sut = try! CoreDataFeedStore(bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
}
