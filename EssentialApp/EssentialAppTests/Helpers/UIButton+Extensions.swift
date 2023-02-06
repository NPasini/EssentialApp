//
//  UIButton+Extensions.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

public extension UIButton {

    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
