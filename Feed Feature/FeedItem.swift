//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Keshav Kishore on 10/10/22.
//

import Foundation


public struct FeedItem: Decodable, Equatable {
    public let id:  UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
