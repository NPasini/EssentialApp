//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by nicolo.pasini on 26/01/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
