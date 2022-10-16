//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Keshav Kishore on 16/10/22.
//

import XCTest



class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}




class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        
        let sut = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
}
  
  
