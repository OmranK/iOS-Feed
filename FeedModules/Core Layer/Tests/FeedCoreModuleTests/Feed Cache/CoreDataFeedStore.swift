//
//  CoreDataFeedStore.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import XCTest
import FeedCoreModule

extension CoreDataFeedStore: ImageDataStore {

    public func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {

    }

    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }

}

class CoreDataFeedImageDataStoreTests: XCTestCase {

    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()

        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }

    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func notFound() -> ImageDataStore.RetrievalResult {
        return .success(.none)
    }

    private func expect(_ sut: CoreDataFeedStore, toCompleteRetrievalWith expectedResult: ImageDataStore.RetrievalResult, for url: URL,  file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.retrieve(dataForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

}
