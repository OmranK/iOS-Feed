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
    internal init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        let _ = primary.loadImageData(from: url, completion: completion)
        return Task()
    }
}

class ImageLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_loadImageData_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let primaryImageData = primaryImageData()
        let fallbackImageData = fallbackImageData()

        let primaryLoader = ImageLoaderStub(result: .success(primaryImageData))
        let fallbackLoader = ImageLoaderStub(result: .success(fallbackImageData))

        let sut = ImageLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
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
    
    // MARK: - Helpers
    
    private func primaryImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func fallbackImageData() -> Data {
        return UIImage.make(withColor: .blue).pngData()!
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
