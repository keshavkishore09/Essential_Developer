//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Keshav Kishore on 11/10/22.
//

import Foundation


enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}


protocol FeedLoader {
    func load (completion: @escaping (LoadFeedResult) -> Void)
}
