//
//  ImageLoaderWithFallbackCompositeTests.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/11/22.
//

import Foundation
import XCTest
import FeedCoreModule

class ImageLoaderWithFallbackComposite: ImageLoader {
    
    private class Task: ImageLoaderTask { func cancel() {} }
    
    let primary: ImageLoader
    let fallback: ImageLoader
    
    internal init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        let _ = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                let _ = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        return Task()
    }
}

class ImageLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_loadImageData_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url])
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty)
    }
    
    func test_loadImageData_deliversFallbackImageDataOnPrimaryLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url])
        XCTAssertEqual(fallbackLoader.loadedURLs, [url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ImageLoaderWithFallbackComposite, ImageLoaderSpy, ImageLoaderSpy) {
        let primaryLoader = ImageLoaderSpy()
        let fallbackLoader = ImageLoaderSpy()
        let sut = ImageLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader)
    }
    
    private func expect(_ sut: ImageLoader, toCompleteWith expectedResult: ImageLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
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
    
    // MARK: - Stub
    
    private class ImageLoaderSpy: ImageLoader {
        
        private class Task: ImageLoaderTask { func cancel() {} }
        
        private var loadRequests = [(url: URL, completion: (ImageLoader.Result) -> Void )]()
        
        var loadedURLs: [URL] {  return loadRequests.map { $0.url } }
        
        func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
            loadRequests.append((url, completion))
            return Task()
        }
        
        func complete(with error: Error, at index: Int = 0) {
            loadRequests[index].completion(.failure(error))
        }
    }
}
