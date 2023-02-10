//
//  ResourceLoadingView.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation

public protocol ResourceLoadingView: AnyObject {
    func display(_ viewModel: ResourceLoadingViewModel)
}
