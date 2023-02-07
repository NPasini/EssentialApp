//
//  RemoteLoader.swift
//  
//
//  Created by nicolo.pasini on 07/02/23.
//

import Foundation

public final class RemoteLoader<Resource> {

    private let url: URL
    private let mapper: Mapper
    private let client: HTTPClient

    public typealias Result = Swift.Result<Resource, Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource

    public init(url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(APIError.connectivity))
            }
        }
    }

    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(APIError.invalidData)
        }
    }
}
