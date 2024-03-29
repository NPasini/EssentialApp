//
//  UIControl+Extensions.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import UIKit

extension UIControl {

    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
