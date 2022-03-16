//
//  FeedImageLoadingPresentationAdapter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import Foundation
import Combine
import FeedCoreModule
import FeedPresentationModule
import FeediOS

final class ImageLoadingPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    
    var presenter: FeedImagePresenter<View, Image>?
    private let model: FeedImage
    
    // MARK: - Composition with Combine Framework + universal abstractions
    
    private let imageLoader: (URL) -> ImageLoader.Publisher
    private var cancellable: Cancellable?
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> ImageLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestLoadImage() {
        presenter?.didStartLoadingImageData(for: model)
        cancellable = imageLoader(model.url).sink(
            receiveCompletion: { [weak self, model] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.presenter?.didFinishLoadingImageData(with: error, for: model)
                }
            }, receiveValue: { [weak self, model] data in
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            })
    }
    
    func didCancelLoadImage() {
        cancellable?.cancel()
    }
    
    // MARK: - Composition with Design Patterns
    
//    private let imageLoader: ImageLoader
//    private var task: ImageLoaderTask?
    
//    init(model: FeedImage, imageLoader: ImageLoader) {
//        self.model = model
//        self.imageLoader = imageLoader
//    }
//
//    func didRequestLoadImage() {
//        presenter?.didStartLoadingImageData(for: model)
//        task = imageLoader.loadImageData(from: model.url) { [weak self, model] result in
//            switch result {
//            case let .success(data):
//                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
//            case let .failure(error):
//                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
//            }
//        }
//    }
    
//    func didCancelLoadImage() {
//        task?.cancel()
//    }
}
