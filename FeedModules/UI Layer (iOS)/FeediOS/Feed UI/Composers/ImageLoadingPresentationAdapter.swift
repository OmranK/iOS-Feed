//
//  FeedImageLoadingPresentationAdapter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import FeedCoreModule

final class ImageLoadingPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(task: FeedImageDataLoaderTask? = nil, model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.task = task
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestLoadImage() {
        presenter?.didStartLoadingImageData(for: model)
        task = imageLoader.loadImageData(from: model.url) { [weak self, model] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            case .failure:
                self?.presenter?.didFinishLoadingImageDataWithError(for: model)
            }
        }
    }
    
    func didCancelLoadImage() {
        task?.cancel()
        task = nil
    }
}
