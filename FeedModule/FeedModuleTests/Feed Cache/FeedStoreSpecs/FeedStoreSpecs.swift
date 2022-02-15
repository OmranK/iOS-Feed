//
//  FeedStoreSpecs.swift
//  FeedModule
//
//  Created by Omran Khoja on 2/10/22.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyCacheOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
    
    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    func test_insert_overridesExistingNonEmptyCache()
    
    func test_deleteCachedFeed_deliversNoErrorOnEmptyCache()
    func test_deleteCachedFeed_hasNoSideEffectsOnEmptyCache()
    func test_deleteCachedFeed_deliversNoErrorOnNonEmptyCache()
    func test_deleteCachedFeed_deletesExistingNonEmptyCache()
    
    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalFailure()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_deleteCachedFeed_deliversErrorOnDeletionError()
    func test_deleteCachedFeed_hasNoSideEffectsOnDeletionError()
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
