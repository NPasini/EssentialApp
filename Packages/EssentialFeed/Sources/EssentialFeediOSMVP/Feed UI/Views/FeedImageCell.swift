//
//  FeedImageCell.swift
//  
//
//  Created by Nicolò Pasini on 12/07/22.
//

import UIKit
import iOSUtilities

public final class FeedImageCell: UITableViewCell {

    @IBOutlet private(set) public var locationLabel: UILabel!
    @IBOutlet private(set) public var descriptionLabel: UILabel!
    @IBOutlet private(set) public var locationContainer: UIView!
    @IBOutlet private(set) public var feedImageView: UIImageView!
    @IBOutlet private(set) public var feedImageContainer: UIView!
    @IBOutlet private(set) public var feedImageRetryButton: UIButton!

    @IBOutlet private(set) var pinImageView: UIImageView!

    var onRetry: (() -> Void)?
    var onReuse: (() -> Void)?

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        pinImageView.image = UIImage.pin
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()

        onReuse?()
    }
}
