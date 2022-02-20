//
//  FeedImageCellController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//
//protocol FeedImageCellControllerDelegate {
//    func didRequestLoadImage()
//    func didCancelLoadImage()
//}
import UIKit



final class FeedImageCellController: ImageView {
    typealias Image = UIImage
    typealias Callback = () -> Void
    
    private lazy var cell = FeedImageCell()
    
    private let load: Callback
    private let cancel: Callback
    
    init(load: @escaping Callback, cancel: @escaping Callback) {
        self.load = load
        self.cancel = cancel
    }
    
//    private let delegate: FeedImageCellControllerDelegate
//    init(delegate: FeedImageCellControllerDelegate) {
//        self.delegate = delegate
//    }
    
    func view() -> UITableViewCell {
        cell.onRetry = load
        load()
        return cell
    }
    
    func display(_ model: ImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !model.hasLocation
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = model.image
        cell.retryButton.isHidden = !model.shouldRetry
        cell.feedImageContainer.isShimmering = model.isLoading
    }

    func preLoad() {
        load()
    }

    func cancelLoad() {
        cancel()
    }
}

