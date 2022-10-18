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



class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // Arrange

        // Act
        let (_, client) = makeSUT()
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // Arrange
        let url = URL(string: "https://a-given-url-com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURL, url)
    }
    
    
    //Mark:- Helpers
    private func makeSUT (url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
         var requestedURL: URL?
         func get(from url: URL) {
            requestedURL = url
        }
        
    }
}
  
  
