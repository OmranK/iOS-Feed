//
//  FeedImagePresenter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/20/22.
//

import Foundation
import FeedModule

protocol FeedImageView {
    associatedtype Image
    func display(_ model: ImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    typealias ImageTransformation = (Data) -> Image?
    
    private let imageTransformer: ImageTransformation
    private let view: View
    
    init(view: View, imageTransformer: @escaping ImageTransformation) {
        self.imageTransformer = imageTransformer
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage){
        view.display(ImageViewModel(description: model.description, location: model.location, image: nil, isLoading: true, shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageDataWithError(for: model)
        }
        view.display(ImageViewModel(description: model.description, location: model.location, image: image, isLoading: false, shouldRetry: false))
    }
    
    func didFinishLoadingImageDataWithError(for model: FeedImage) {
        view.display(ImageViewModel(description: model.description, location: model.location, image: nil, isLoading: false, shouldRetry: true))
    }
}
