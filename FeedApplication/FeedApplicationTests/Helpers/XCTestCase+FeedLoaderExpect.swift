//
//  XCTestCase+FeedLoaderExpect.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import FeedCoreModule
import XCTest

protocol FeedLoaderTestCase: XCTestCase { }

extension FeedLoaderTestCase {
    
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImageData), .success(expectedImageData)):
                XCTAssertEqual(receivedImageData, expectedImageData, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                 XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
    }
}
