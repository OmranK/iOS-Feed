//
//  ImageLoaderCacheDecoratorTests.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import XCTest
import FeedCoreModule

protocol ImageCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

class ImageLoaderCacheDecorator: ImageLoader {
    let decoratee: ImageLoader
    let cache: ImageCache
    
    internal init(decoratee: ImageLoader, cache: ImageCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            if let imageData = try? result.get() {
                self?.cache.save(imageData, for: url) { _ in }
            }
            completion(result)
        }
    }
}

class ImageLoaderCacheDecoratorTests: XCTestCase, ImageLoaderTestCase {
    
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
    
    func test_loadImageData_cachesImageOnLoaderSuccess() {
        let cache = ImageCacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        
        let url = anyURL()
        let imageData = anyData()
        let _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: imageData)
        
        XCTAssertEqual(cache.messages, [.save(data: imageData, for: url)])
    }
    
    func test_loadImageData_doesNotAttemptCacheingOnLoaderFailure() {
        let cache = ImageCacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        
        let url = anyURL()
        let error = anyNSError()
        let _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: error)
        
        XCTAssertEqual(cache.messages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(cache: ImageCacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: ImageLoaderCacheDecorator, loader: ImageLoaderSpy) {
        let loader = ImageLoaderSpy()
        let sut = ImageLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func anyData() -> Data {
        return Data("data".utf8)
    }

    private class ImageCacheSpy: ImageCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(data: Data, for: URL)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (ImageCache.Result) -> Void) {
            messages.append(.save(data: data, for: url))
            completion(.success(()))
        }
    }
}
