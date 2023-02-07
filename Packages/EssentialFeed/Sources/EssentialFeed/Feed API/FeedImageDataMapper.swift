//
//  FeedImageDataMapper.swift
//  
//
//  Created by nicolo.pasini on 07/02/23.
//

import Foundation

public enum FeedImageDataMapper {
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw APIError.invalidData
        }
        
        return data
    }
}
