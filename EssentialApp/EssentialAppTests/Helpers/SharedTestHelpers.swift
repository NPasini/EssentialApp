//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Nicolò Pasini on 22/08/22.
//

import Foundation
import EssentialFeed

public func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

public func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

public func anyData() -> Data {
    Data("any data".utf8)
}
