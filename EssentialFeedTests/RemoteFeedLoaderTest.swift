//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 16/10/22.
//

import XCTest


class RemoteFeedLoader {
    let client: HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

 
protocol HTTPClient {
    func get(from url: URL)
}


class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
     func get(from url: URL) {
        requestedURL = url
    }
    
}


class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
         
        // Act
        _ = RemoteFeedLoader(client: client)
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertNotNil(client.requestedURL)
    }
}
  
  
