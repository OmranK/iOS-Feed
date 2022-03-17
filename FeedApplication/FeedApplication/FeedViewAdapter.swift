//
//  FeedViewAdapter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import UIKit
import Foundation
import FeedCoreModule
import FeedPresentationModule
import FeediOS

final class FeedViewAdapter: FeedView {
    private weak var feedController: FeedViewController?
    
    // MARK: - Composition with Combine Framework + universal abstractions
    
    private let imageLoader: (URL) -> ImageLoader.Publisher
    
    init(feedController: FeedViewController, imageLoader: @escaping (URL) -> ImageLoader.Publisher){
        self.feedController = feedController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewVM) {
        feedController?.display(viewModel.feed.map { model in
            let adapter = ImageLoadingPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            return view
        })
    }
    
    // MARK: - Composition with Design Patterns
    
//    private let imageLoader: ImageLoader
//
//    init(feedController: FeedViewController, imageLoader: ImageLoader){
//        self.feedController = feedController
//        self.imageLoader = imageLoader
//    }
//
//    func display(_ viewModel: FeedViewVM) {
//        feedController?.display(viewModel.feed.map { model in
//            let adapter = ImageLoadingPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
//            let view = FeedImageCellController(delegate: adapter)
//            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
//            return view
//        })
//    }

}
