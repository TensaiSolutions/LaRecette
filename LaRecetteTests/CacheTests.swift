//
//  CacheTests.swift
//  LaRecette
//
//  Created by philip sidell on 3/12/25.
//
import Testing
@testable import LaRecette

@Suite("Cache Tests")
struct CacheTests {
    let cache = LRUCache<String, Int>(capacity: 7)
    
    @Test("Cache should be empty")
    func testCache_Empty() {
        #expect(cache.linkedList.head == nil)
        #expect(cache.linkedList.tail == nil)
        #expect(cache.linkedList.count == 0)
    }
    
    @Test("Cache add 1 item to cache")
    func testCache_AddOneItem() {
        cache.setObject(for: "Test1", value: 42)
        
        #expect(cache.linkedList.head?.payload.key == "Test1")
        #expect(cache.linkedList.tail?.payload.key == "Test1")
        #expect(cache.linkedList.head?.payload.value == 42)
        #expect(cache.linkedList.tail?.payload.value == 42)
        #expect(cache.linkedList.count == 1)
        
        #expect(cache.dictionary["Test1"]?.payload.value == 42)
    }
    
    @Test("Cache add 3 items to cache")
    func testCache_AddThreeItems() {
        cache.setObject(for: "Test1", value: 42)
        cache.setObject(for: "Test2", value: 1337)
        cache.setObject(for: "Test3", value: 666)
        
        #expect(cache.linkedList.head?.payload.key == "Test3")
        #expect(cache.linkedList.tail?.payload.key == "Test1")
        #expect(cache.linkedList.head?.payload.value == 666)
        #expect(cache.linkedList.tail?.payload.value == 42)
        #expect(cache.linkedList.count == 3)
        
        #expect(cache.dictionary["Test1"]?.payload.value == 42)
        #expect(cache.dictionary["Test2"]?.payload.value == 1337)
        #expect(cache.dictionary["Test3"]?.payload.value == 666)
        
    }
    
    
    
    
}
