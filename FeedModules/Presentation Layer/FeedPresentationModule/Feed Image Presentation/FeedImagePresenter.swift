//
//  FeedImagePresenter.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/9/22.
//

import Foundation
import FeedCoreModule

public protocol FeedImageView {
    associatedtype Image
    func display(_ model: FeedImageViewVM<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    public typealias ImageTransformation = (Data) -> Image?

    private let view: View
    private let imageTransformer: ImageTransformation
    
    public init(view: View, imageTransformer: @escaping ImageTransformation) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage){
        view.display(FeedImageViewVM(description: model.description, location: model.location, image: nil, isLoading: true, shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        let image = imageTransformer(data)
        view.display(FeedImageViewVM(description: model.description, location: model.location, image: image, isLoading: false, shouldRetry: image == nil))
    }
    
    
    public func didFinishLoadingImageData(with: Error, for model: FeedImage) {
        view.display(FeedImageViewVM(description: model.description, location: model.location, image: nil, isLoading: false, shouldRetry: true))
    }
    
}
