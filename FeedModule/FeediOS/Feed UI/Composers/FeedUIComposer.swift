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
        let presentationAdapter = FeedLoadingPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.refreshController = refreshController
        
        let presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(refreshController),
            feedView:  FeedViewAdapter(feedController: feedController, imageLoader: imageLoader))
        
        presentationAdapter.presenter = presenter
        
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
        feedController?.viewModel = viewModel.feed.map { model in
            let adapter = ImageLoadingPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            return view
        }
    }
}


final private class FeedLoadingPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(feed: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}


final private class ImageLoadingPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
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

extension WeakRefVirtualProxy: FeedImageView where T:FeedImageView, T.Image == UIImage {
    typealias Image = T.Image
    
    func display(_ model: ImageViewModel<Image>) {
        object?.display(model)
    }
}


