//
//  FeedImageCell.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/17/22.
//

import UIKit

final public class FeedImageCell: UITableViewCell {
    public var locationContainer = UIView()
    public var locationLabel = UILabel()
    public var descriptionLabel = UILabel()
    public var feedImageContainer = UIView()
    public var feedImageView = UIImageView()
    
    private(set) public lazy var retryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
