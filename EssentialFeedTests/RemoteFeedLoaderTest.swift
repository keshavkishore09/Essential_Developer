//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 16/10/22.
//
 
import XCTest
import EssentialFeed

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // Arrange

        // Act
        let (_, client) = makeSUT()
        
        // Assert
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    
    func test_load_requestsDataFromURL() {
        // Arrange
        let url = URL(string: "https://a-given-url-com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    func test_loadtwice_requestsDataFromURLTwice() {
        // Arrange
        let url = URL(string: "https://a-given-url-com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load()
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURLs,[url, url])
    }
    
    
    func test_load_deliversOnClientError() {
        // Arrange
        let (sut, client) = makeSUT()
        client.error = NSError(domain:"Test", code: 0)
        var capturedError: RemoteFeedLoader.Error?
        
        // Act
        sut.load { error in capturedError = error }
        
        // Assert
        XCTAssertEqual(capturedError, .connectivity)
        
        
    }
    
    //Mark:- Helpers
    private func makeSUT (url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
         var requestedURLs = [URL]()
         var error: Error?
    
         func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
        
    }
}
  
  
