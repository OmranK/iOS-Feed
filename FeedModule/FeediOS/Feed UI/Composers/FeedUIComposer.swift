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
        let feedPresenter = FeedPresenter()
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader, presenter: feedPresenter)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        feedPresenter.loadingView = WeakRefVirtualProxy(refreshController)
        feedPresenter.feedView = FeedViewAdapter(feedController: feedController, imageLoader: imageLoader)
        return feedController
    }
}

final private class FeedViewAdapter: FeedView {
    private weak var feedController: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(feedController: FeedViewController, imageLoader: FeedImageDataLoader){
        self.feedController = feedController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        feedController?.viewModel = viewModel.feed.map {
            FeedImageCellController(imageViewModel: FeedImageViewModel(model: $0, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}

final private class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let feedLoader: FeedLoader
    private let presenter: FeedPresenter
    
    init(feedLoader: FeedLoader, presenter: FeedPresenter) {
        self.feedLoader = feedLoader
        self.presenter = presenter
    }
    
    func didRequestFeedRefresh() {
        presenter.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter.didFinishLoadingFeed(feed: feed)
            case let .failure(error):
                self?.presenter.didFinishLoadingFeed(with: error)
            }
        }
    }
    
}

final private class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}


