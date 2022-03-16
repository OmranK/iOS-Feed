//
//  FeedLoaderWithFallbackComposite.swift
//  FeedApplication
//
//  Created by Omran Khoja on 3/11/22.
//

import Foundation
import FeedCoreModule

public final class ImageLoaderWithFallbackComposite: ImageLoader {
    
    private class TaskWrapper: ImageLoaderTask {
        var wrapped: ImageLoaderTask?
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    private let primary: ImageLoader
    private let fallback: ImageLoader
    
    public init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
}
