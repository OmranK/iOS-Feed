//
//  FeedImageViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import Foundation
import FeedModule

final class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    typealias ImageTransformation = (Data) -> Image?
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    var onImageLoadingStateChange: Observer<Bool>?
    var onSucessfulImageLoad: Observer<Image?>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping ImageTransformation) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var location: String? {
        return model.location
    }
    
    var hasLocation: Bool {
        return model.location != nil
    }
    
    var description: String? {
        return model.description
    }
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onSucessfulImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
}
