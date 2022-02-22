//
//  FeedImageCellController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestLoadImage()
    func didCancelLoadImage()
}

final class FeedImageCellController: FeedImageView {
    typealias Image = UIImage
    private var cell: FeedImageCell?
    
    private let delegate: FeedImageCellControllerDelegate
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestLoadImage()
        return cell!
    }
    
    func display(_ model: ImageViewModel<UIImage>) {
        cell?.locationContainer.isHidden = !model.hasLocation
        cell?.locationLabel.text = model.location
        cell?.descriptionLabel.text = model.description
        cell?.feedImageView.image = model.image
        cell?.retryButton.isHidden = !model.shouldRetry
        cell?.feedImageContainer.isShimmering = model.isLoading
        cell?.onRetry = delegate.didRequestLoadImage
    }

    func preLoad() {
        delegate.didRequestLoadImage()
    }

    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelLoadImage()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
