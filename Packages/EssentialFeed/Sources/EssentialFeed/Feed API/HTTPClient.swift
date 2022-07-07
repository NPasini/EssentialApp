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

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to disptach to approriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
