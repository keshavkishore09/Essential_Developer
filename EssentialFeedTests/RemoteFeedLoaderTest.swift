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
        sut.load{ _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    func test_loadtwice_requestsDataFromURLTwice() {
        // Arrange
        let url = URL(string: "https://a-given-url-com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load{ _ in }
        sut.load{ _ in }
        
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
    
    
    func test_load_deliversOnNon200HTTPResponse() {
        // Arrange
        let (sut, client) = makeSUT()
        
        let samples =  [199, 201, 300, 400, 500]
        
       samples.enumerated().forEach { index, code in
            
            var capturedErrors =  [RemoteFeedLoader.Error]()
            
            // Act
            sut.load { capturedErrors.append($0)}
            client.complete(withStatusCode: code, at: index)
            
            // Assert
            XCTAssertEqual(capturedErrors, [.invalidData])
  
            capturedErrors = []
        }
        
       
        
        
    }
    
    //Mark:- Helpers
    private func makeSUT (url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [ (url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
         func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
             messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0)   {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0)   {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(response))
        }
        
    }
}
  
  
