//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedModule
import UIKit

public final class FeedUIComposer {
    private init() {}
    
    public static func feedControllerComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onSuccessfulLoad = adaptFeedToCellControllers(forwardingTo: feedController, using: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, using loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.viewModel = feed.map {
                FeedImageCellController(imageViewModel: FeedImageViewModel(model: $0, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}
