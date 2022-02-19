//
//  FeedImageCellController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

final class FeedImageCellController {
    
    private var imageViewModel: FeedImageViewModel<UIImage>
    
    init(imageViewModel: FeedImageViewModel<UIImage>) {
        self.imageViewModel = imageViewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        imageViewModel.loadImageData()
        return cell
    }
     
    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !imageViewModel.hasLocation
        cell.locationLabel.text = imageViewModel.location
        cell.descriptionLabel.text = imageViewModel.description
        cell.onRetry = imageViewModel.loadImageData
        
        imageViewModel.onSucessfulImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
            cell?.retryButton.isHidden = (image != nil)
        }
        
        imageViewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }
        
        imageViewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.retryButton.isHidden = !shouldRetry
        }
    
        return cell
    }
    
    func preLoad() {
        imageViewModel.loadImageData()
    }
    
    func cancelLoad() {
        imageViewModel.cancelImageLoad()
    }
}

