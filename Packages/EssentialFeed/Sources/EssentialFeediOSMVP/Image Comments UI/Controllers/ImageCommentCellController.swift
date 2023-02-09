//
//  ImageCommentCellController.swift
//  
//
//  Created by nicolo.pasini on 09/02/23.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.dateLabel.text = model.date
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        return cell
    }
}
