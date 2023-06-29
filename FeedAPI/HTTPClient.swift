//
//  HTTPClient.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 29/06/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
