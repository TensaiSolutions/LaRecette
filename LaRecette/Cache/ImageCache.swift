//
//  ImageCache.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import Foundation

@MainActor
final class ImageCache:Sendable {
    
    typealias CacheType = LRUCache<NSString, NSData>
    
    @MainActor static let shared = ImageCache()
    
    private init() { }
    
    private lazy var cache: CacheType = {
        @MainActor in LRUCache(capacity: 100)
    }()
        
    func getObject(forkey key: NSString) -> Data? {
        cache.retrieveObject(at: key) as Data?
    }
    
    func setObject(object: NSData, forKey key: NSString) {
        cache.setObject(for: key, value: object)
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
