//
//  ImageLoaderCacheDecoratorTests.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import XCTest
import FeedCoreModule

class ImageLoaderCacheDecorator: ImageLoader {
    let decoratee: ImageLoader
    
    internal init(decoratee: ImageLoader) {
        self.decoratee = decoratee
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}

class ImageLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        XCTAssertTrue(loader.loadedURLs.isEmpty)
    }
    
    func test_loadImageData_requestsImageDataFromLoader() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedURLs, [url])
    }
    
    func test_loadImageData_cancelsLoaderTask() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.cancelledURLs, [url])
    }

    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let (sut, loader) = makeSUT()
        
        let imageData = anyData()
        expect(sut, toCompleteWith: .success(imageData)) {
            loader.complete(with: imageData)
        }
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        let error = anyNSError()
        expect(sut, toCompleteWith: .failure(error)) {
            loader.complete(with: error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ImageLoaderCacheDecorator, loader: ImageLoaderSpy) {
        let loader = ImageLoaderSpy()
        let sut = ImageLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
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
    
    private func anyData() -> Data {
        return Data("data".utf8)
    }
    
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
