//
//  ImageCache.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import Foundation

class ImageCache {
    
    typealias CacheType = LRUCache<NSString, NSData>
    
    static let shared = ImageCache()
    
    private init() { }
    
    private lazy var cache: CacheType = {
        LRUCache(capacity: 100)
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
