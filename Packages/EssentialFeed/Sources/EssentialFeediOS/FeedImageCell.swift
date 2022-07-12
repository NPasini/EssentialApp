//
//  FeedImageCell.swift
//  
//
//  Created by Nicolò Pasini on 12/07/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {

    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let locationContainer = UIView()
    public let feedImageView = UIImageView()
    public let feedImageContainer = UIView()

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
