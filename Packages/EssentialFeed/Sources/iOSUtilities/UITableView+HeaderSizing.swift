//
//  UITableView+HeaderSizing.swift
//  
//
//  Created by nicolo.pasini on 26/01/23.
//

import UIKit

extension UITableView {
    
    public func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }

        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
