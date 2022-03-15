//
//  FeedImageCellController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit
import FeedPresentationModule

public protocol FeedImageCellControllerDelegate {
    func didRequestLoadImage()
    func didCancelLoadImage()
}

public final class FeedImageCellController: FeedImageView {
    public typealias Image = UIImage
    private var cell: FeedImageCell?
    
    private let delegate: FeedImageCellControllerDelegate
    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestLoadImage()
        return cell!
    }
    
    public func display(_ model: FeedImageViewVM<UIImage>) {
        cell?.locationContainer.isHidden = !model.hasLocation
        cell?.locationLabel.text = model.location
        cell?.descriptionLabel.text = model.description
        
        cell?.feedImageView.image = model.image
        cell?.feedImageView.setImageWithAnimation(model.image)
        
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


