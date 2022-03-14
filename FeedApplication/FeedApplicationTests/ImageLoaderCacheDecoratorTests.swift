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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ImageLoaderCacheDecorator, loader: ImageLoaderSpy) {
        let loader = ImageLoaderSpy()
        let sut = ImageLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func anyData() -> Data {
        return Data("data".utf8)
    }
}
