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
        let primaryImageData = primaryImageData()
        let fallbackImageData = fallbackImageData()
        
        let sut = makeSUT(primaryResult: .success(primaryImageData), fallbackResult: .success(fallbackImageData))
        let url = URL(string: "http://any-url.com")!
        
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedImageData):
                XCTAssertEqual(receivedImageData, primaryImageData)
            case .failure:
                 XCTFail("Expected successful image load result, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func test_loadImageData_deliversFallbackImageDataOnPrimaryLoaderFailure() {
        let fallbackImageData = fallbackImageData()
        
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackImageData))
        let url = URL(string: "http://any-url.com")!
        
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedImageData):
                XCTAssertEqual(receivedImageData, fallbackImageData)
            case .failure:
                 XCTFail("Expected successful image load result, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(primaryResult: ImageLoader.Result, fallbackResult: ImageLoader.Result, file: StaticString = #file, line: UInt = #line) -> ImageLoaderWithFallbackComposite {
        let primaryLoader = ImageLoaderStub(result: primaryResult)
        let fallbackLoader = ImageLoaderStub(result: fallbackResult)
        let sut = ImageLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func primaryImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func fallbackImageData() -> Data {
        return UIImage.make(withColor: .blue).pngData()!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    // MARK: - Stub
    
    private class ImageLoaderStub: ImageLoader {
        
        private class Task: ImageLoaderTask { func cancel() {} }
        
        private let result: ImageLoader.Result
        internal init(result: ImageLoader.Result) {
            self.result = result
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
            completion(result)
            return Task()
        }
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
