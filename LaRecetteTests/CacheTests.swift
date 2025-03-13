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
    
    @Test("Test add Duplicate Object. Should be at head and only 2 values")
    func testCache_AddDuplicateObject() {
        cache.setObject(for: "Test1", value: 42)
        cache.setObject(for: "Test2", value: 666)
        cache.setObject(for: "Test2", value: 1337)
        
        #expect(cache.linkedList.head?.payload.key == "Test2")
        #expect(cache.linkedList.tail?.payload.key == "Test1")
        #expect(cache.linkedList.head?.payload.value == 1337)
        #expect(cache.linkedList.tail?.payload.value == 42)
        #expect(cache.linkedList.count == 2)
        
        #expect(cache.dictionary.count == 2)
        #expect(cache.dictionary["Test1"]?.payload.value == 42)
        #expect(cache.dictionary["Test2"]?.payload.value == 1337)
        
    }
    
    @Test("Test add Object to Full Cache. Expect Cache to remove Tail Object")
    func testCache_AddObjectToFullCache() {
        cache.setObject(for: "Test1", value: 42)
        cache.setObject(for: "Test2", value: 666)
        cache.setObject(for: "Test3", value: 1337)
        cache.setObject(for: "Test4", value: 84)
        cache.setObject(for: "Test5", value: 123)
        cache.setObject(for: "Test6", value: 54)
        cache.setObject(for: "Test7", value: 333)
        cache.setObject(for: "Test8", value: 32)
        
        #expect(cache.linkedList.head?.payload.key == "Test8")
        #expect(cache.linkedList.tail?.payload.key == "Test2")
        #expect(cache.linkedList.head?.payload.value == 32)
        #expect(cache.linkedList.tail?.payload.value == 666)
        #expect(cache.linkedList.count == 7)
        
        #expect(cache.dictionary.count == 7)
        #expect(cache.dictionary["Test1"]?.payload.value == nil)
        #expect(cache.dictionary["Test2"]?.payload.value == 666)
        #expect(cache.dictionary["Test3"]?.payload.value == 1337)
        #expect(cache.dictionary["Test4"]?.payload.value == 84)
        #expect(cache.dictionary["Test5"]?.payload.value == 123)
        #expect(cache.dictionary["Test6"]?.payload.value == 54)
        #expect(cache.dictionary["Test7"]?.payload.value == 333)
        #expect(cache.dictionary["Test8"]?.payload.value == 32)

    }
    
    @Test("Add Object to Full Cache, with Duplicates should remove Least Used")
    func testCache_AddObjectToFullCacheWithDuplicates() {
        cache.setObject(for: "Test1", value: 42)
        cache.setObject(for: "Test2", value: 666)
        cache.setObject(for: "Test3", value: 1337)
        cache.setObject(for: "Test4", value: 84)
        cache.setObject(for: "Test5", value: 123)
        cache.setObject(for: "Test6", value: 54)
        cache.setObject(for: "Test7", value: 333)
        cache.setObject(for: "Test8", value: 32)
        cache.setObject(for: "Test7", value: 22)
        
        
        #expect(cache.linkedList.head?.payload.key == "Test7")
        #expect(cache.linkedList.tail?.payload.key == "Test2")
        #expect(cache.linkedList.head?.payload.value == 22)
        #expect(cache.linkedList.tail?.payload.value == 666)
        #expect(cache.linkedList.count == 7)
        
    }
    
    @Test("Access an Element in the Cache, Should Return Success")
    func testCache_AccessElementInCache() {
        
        cache.setObject(for: "Test1", value: 42)
        cache.setObject(for: "Test2", value: 666)
        
        #expect(cache.retrieveObject(at: "Test2") == 666)
        
    }
}
