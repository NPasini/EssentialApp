//
//  URLSessionHTTPClient.swift
//  
//
//  Created by Nicolò Pasini on 12/06/22.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    private struct UnexpectedValuesRepresentation: Error {}

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}
