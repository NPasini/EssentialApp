//
//  FeedImageCell+TestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit
import EssentialFeediOS
import EssentialFeediOSMVC

extension FeedImageCell {

    var locationText: String? { locationLabel.text }
    var descriptionText: String? { descriptionLabel.text }
    var renderedImage: Data? { feedImageView.image?.pngData() }
    var isShowingLocation: Bool { !locationContainer.isHidden }
    var isShowingRetryAction: Bool { !feedImageRetryButton.isHidden }
    var isShowingImageLoadingIndicator: Bool { feedImageContainer.isShimmering }

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
