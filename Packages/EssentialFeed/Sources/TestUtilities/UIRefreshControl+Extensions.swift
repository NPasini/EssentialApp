//
//  UIRefreshControl+Extensions.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

public extension UIRefreshControl {

    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
