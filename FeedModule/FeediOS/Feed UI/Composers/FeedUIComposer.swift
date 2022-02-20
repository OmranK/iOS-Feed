//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedModule
import UIKit

final public class FeedUIComposer {
    private init() {}
    
    public static func feedControllerComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewPresenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewPresenter: feedViewPresenter)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewPresenter.loadingView = refreshController
        feedViewPresenter.feedView = FeedViewAdapter(feedController: feedController, imageLoader: imageLoader)
        return feedController
    }
}

private class FeedViewAdapter: FeedView {
    
    private weak var feedController: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(feedController: FeedViewController, imageLoader: FeedImageDataLoader){
        self.feedController = feedController
        self.imageLoader = imageLoader
    }
    
    func display(feed: [FeedImage]) {
        feedController?.viewModel = feed.map {
            FeedImageCellController(imageViewModel: FeedImageViewModel(model: $0, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}
