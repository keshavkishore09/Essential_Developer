//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 16/10/22.
//
 
import XCTest


class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    func load() {
        client.get(from: url)
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
        let url = URL(string: "https://a-url.com")!
        // Act
        _ = RemoteFeedLoader(url: url, client: client)
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-given-url-com")!
        let sut = RemoteFeedLoader(url: url, client: client)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURL, url)
    }
}
  
  
