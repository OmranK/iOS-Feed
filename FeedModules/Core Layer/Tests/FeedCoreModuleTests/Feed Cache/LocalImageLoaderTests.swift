//
//  LocalImageLoaderTests.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import XCTest
import FeedCoreModule

final class LocalImageLoader {
    init(store: Any) {

    }
}

class LocalImageLoaderTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalImageLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private class FeedStoreSpy {
        let receivedMessages = [Any]()
    }

}
