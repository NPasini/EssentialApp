//
//  HTTPClientSpy.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation
import EssentialFeed

class HTTPClientSpy: HTTPClient {

    private(set) var receivedMessages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

    var requestedURLs: [URL] {
        receivedMessages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        receivedMessages.append((url, completion))
    }

    func complete(with error: Error, at index: Int = 0) {
        receivedMessages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: receivedMessages[index].url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!

        receivedMessages[index].completion(.success((data, response)))
    }
}
