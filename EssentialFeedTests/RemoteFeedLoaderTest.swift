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
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    
    func test_load_deliversOnNon200HTTPResponse() {
        // Arrange
        let (sut, client) = makeSUT()
        
        let samples =  [199, 201, 300, 400, 500]
        
       samples.enumerated().forEach { index, code in
           expect(sut, toCompleteWithResult: .failure(.invalidData)) {
               let json = makeItemsJSON([])
               client.complete(withStatusCode: code, data: json, at: index)
           }
      
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
  }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONLists() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJson = makeItemsJSON([])
            client.complete(withStatusCode: 200,  data: emptyListJson)
        }
    }
    
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        
        let(sut, client) = makeSUT()
        let item1 = makeItem(
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "https//a-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https//another-url.com")!)
        
    
        let items = [item1.model, item2.model]
        expect(sut, toCompleteWithResult: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    
    
    //Mark:- Helpers
    
    private func makeSUT (url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt =  #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leaks",file: file, line: line)
        }
    }
    
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString].reduce(into: [String: Any]()){(acc,e) in
                if let value = e.value {acc[e.key] = value }
            }
        return(item, json)
    }
    
    
    func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action: () -> Void,file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults =  [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0)}
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
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
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0)   {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
        
    }
}
  
  
