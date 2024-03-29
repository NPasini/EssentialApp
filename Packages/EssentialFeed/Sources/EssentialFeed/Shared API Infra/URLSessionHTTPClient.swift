//
//  URLSessionHTTPClient.swift
//  
//
//  Created by Nicolò Pasini on 12/06/22.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }

    private struct UnexpectedValuesRepresentation: Error {}

    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    @discardableResult
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}

//extension URLSession: HTTPClient {
//
//    private struct UnexpectedValuesRepresentation: Error {}
//
//    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
//        dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data, let response = response as? HTTPURLResponse {
//                completion(.success(data, response))
//            } else {
//                completion(.failure(UnexpectedValuesRepresentation()))
//            }
//        }.resume()
//    }
//}
