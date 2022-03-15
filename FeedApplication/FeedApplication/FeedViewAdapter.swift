//
//  FeedViewAdapter.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import UIKit
import FeedCoreModule
import FeedPresentationModule
import FeediOS

final class FeedViewAdapter: FeedView {
    private weak var feedController: FeedViewController?
    private let imageLoader: ImageLoader
    
    init(feedController: FeedViewController, imageLoader: ImageLoader){
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
}
