//
//  UITableView+Dequeueing.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        return dequeueReusableCell(withIdentifier: identifier) as! Cell
    }
}
