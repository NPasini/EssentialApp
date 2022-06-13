//
//  HTTPClient.swift
//  
//
//  Created by Nicolò Pasini on 07/06/22.
//

import Foundation

public enum HTTPClientResult {
    case failure(Error)
    case success(Data, HTTPURLResponse)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
