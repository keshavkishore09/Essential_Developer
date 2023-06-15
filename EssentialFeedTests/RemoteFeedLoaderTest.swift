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
        var capturedErrors =  [RemoteFeedLoader.Error]()
        
        // Act
        sut.load { capturedErrors.append($0)}
        
        
        let clientError = NSError(domain: "Test", code: 0)
        
        client.complete(with: clientError)
        
        // Assert
        XCTAssertEqual(capturedErrors, [.connectivity])
        
        
    }
    
    //Mark:- Helpers
    private func makeSUT (url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [ (url: URL, completion: (Error) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
         func get(from url: URL, completion: @escaping (Error) -> Void) {
             messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0)   {
            messages[index].completion(error)
        }
        
    }
}
  
  
