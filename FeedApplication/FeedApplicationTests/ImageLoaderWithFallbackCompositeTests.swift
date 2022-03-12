//
//  ImageLoaderWithFallbackCompositeTests.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/11/22.
//

import XCTest
import FeedCoreModule
import FeedApplication

class ImageLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_loadImageData_requestsPrimaryImageDataOnPrimaryLoaderSuccess() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url])
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty)
    }
    
    func test_loadImageData_requestsFallbackImageDataOnPrimaryLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url])
        XCTAssertEqual(fallbackLoader.loadedURLs, [url])
    }
    
    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryLoader.cancelledURLs, [url], "Expected to cancel URL loading from primary loader")
        XCTAssertTrue(fallbackLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsFallbackLoaderTaskAfterPrimaryLoaderFailure() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        task.cancel()
        
        XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the primary loader")
        XCTAssertEqual(fallbackLoader.cancelledURLs, [url], "Expected to cancel URL loading from fallback loader")
    }
    
    
    func test_loadImageData_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let (sut, primaryLoader, _) = makeSUT()
    
        let primaryImageData = primaryData()
        
        expect(sut, toCompleteWith: .success(primaryImageData), when: {
            primaryLoader.complete(with: primaryImageData)
        })
    }
    
    
    func test_loadImageData_deliversFallbackImageDataOnFallbackLoaderSuccessAfterPrimaryLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
        let fallbackImageData = fallbackData()
        
        expect(sut, toCompleteWith: .success(fallbackImageData), when: {
            primaryLoader.complete(with: anyNSError())
            fallbackLoader.complete(with: fallbackImageData)
        })
    }
    
    func test_loadImageData_deliversErrorWhenBothLoadersFail() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
        let error = anyNSError()
        
        expect(sut, toCompleteWith: .failure(error), when: {
            primaryLoader.complete(with: error)
            fallbackLoader.complete(with: error)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ImageLoaderWithFallbackComposite, ImageLoaderSpy, ImageLoaderSpy) {
        let primaryLoader = ImageLoaderSpy()
        let fallbackLoader = ImageLoaderSpy()
        let sut = ImageLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader)
    }
    
    private func expect(_ sut: ImageLoader, toCompleteWith expectedResult: ImageLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
        action()
        wait(for: [exp], timeout: 3.0)
    }
    
    private func primaryData() -> Data {
        return Data("primary data".utf8)
    }
    
    private func fallbackData() -> Data {
        return Data("fallback data".utf8)
    }

    // MARK: - Stub
    
    private class ImageLoaderSpy: ImageLoader {
        private struct Task: ImageLoaderTask {
            let callback: () -> Void
            func cancel() { callback() }
        }
        
        private var loadRequests = [(url: URL, completion: (ImageLoader.Result) -> Void )]()
        var loadedURLs: [URL] {  return loadRequests.map { $0.url } }
        private(set) var cancelledURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
            loadRequests.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }
        
        func complete(with error: Error, at index: Int = 0) {
            loadRequests[index].completion(.failure(error))
        }
        
        func complete(with data: Data, at index: Int = 0) {
            loadRequests[index].completion(.success(data))
        }
    }
}

