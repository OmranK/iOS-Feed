//
//  FeedImagePresenter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/20/22.
//

import Foundation
import FeedModule

protocol ImageView {
    associatedtype Image
    func display(_ model: ImageViewModel<Image>)
}

final class FeedImagePresenter<View: ImageView, Image> where View.Image == Image {
    
    typealias ImageTransformation = (Data) -> Image?
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: ImageTransformation
    
    var view: View?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping ImageTransformation) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData() {
        view?.display(ImageViewModel(description: model.description, location: model.location, image: nil, isLoading: true, shouldRetry: false))
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            view?.display(ImageViewModel(description: model.description, location: model.location, image: image, isLoading: true, shouldRetry: false))
        } else {
            view?.display(ImageViewModel(description: model.description, location: model.location, image: nil, isLoading: false, shouldRetry: true))
        }
    }
    
    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
}
