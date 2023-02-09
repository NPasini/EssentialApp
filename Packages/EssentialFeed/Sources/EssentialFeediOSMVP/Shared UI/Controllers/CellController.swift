//
//  CellController.swift
//  
//
//  Created by nicolo.pasini on 09/02/23.
//

import UIKit

public struct CellController {
    let id: AnyHashable
    let datasource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(id: AnyHashable, _ datasource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.id = id
        self.delegate = datasource
        self.datasource = datasource
        self.dataSourcePrefetching = datasource
    }
    
    public init(id: AnyHashable, _ datasource: UITableViewDataSource) {
        self.id = id
        self.delegate = nil
        self.datasource = datasource
        self.dataSourcePrefetching = nil
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
