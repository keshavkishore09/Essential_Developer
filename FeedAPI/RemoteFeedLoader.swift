//
//  RemoteFeedLoader.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 20/10/22.
//

import Foundation
import EssentialFeed


public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let  .success(data, response):
                //completion(self.map(data, from: response))
                do {
                    let items = try FeedItemsMapper.map(data, response: response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}




