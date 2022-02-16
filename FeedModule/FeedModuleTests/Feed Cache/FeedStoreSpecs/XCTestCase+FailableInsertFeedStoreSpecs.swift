//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import XCTest
import FeedModule

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
