//
//  FeedLoaderCacheDecorator.swift
//  FeedApplication
//
//  Created by Omran Khoja on 3/13/22.
//

import Foundation
import FeedCoreModule

public class ImageLoaderCacheDecorator: ImageLoader {
    let decoratee: ImageLoader
    let cache: ImageCache
    
    public init(decoratee: ImageLoader, cache: ImageCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            if let imageData = try? result.get() {
                self?.cache.save(imageData, for: url) { _ in }
            }
            completion(result)
        }
    }
}
