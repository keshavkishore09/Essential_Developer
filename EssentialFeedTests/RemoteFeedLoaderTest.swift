//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 16/10/22.
//

import XCTest


class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}


class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {}
}


class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    override func get(from url: URL) {
        requestedURL = url
    }
    
}


class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        HTTPClient.shared = client
         
        // Act
        _ = RemoteFeedLoader()
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertNotNil(client.requestedURL)
    }
}
  
  
