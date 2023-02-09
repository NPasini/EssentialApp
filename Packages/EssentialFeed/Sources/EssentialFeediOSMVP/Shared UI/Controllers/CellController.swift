//
//  CellController.swift
//  
//
//  Created by nicolo.pasini on 09/02/23.
//

import UIKit

public struct CellController {
    public let datasource: UITableViewDataSource
    public let delegate: UITableViewDelegate?
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(_ datasource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.delegate = datasource
        self.datasource = datasource
        self.dataSourcePrefetching = datasource
    }
    
    public init(_ datasource: UITableViewDataSource) {
        self.delegate = nil
        self.datasource = datasource
        self.dataSourcePrefetching = nil
    }
}
