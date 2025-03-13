//
//  LRUCache.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

class LRUCache<T: Hashable, U> {
    
    private(set) var capacity: UInt
    private(set) var linkedList = DoubleLinkedList<CachePayload<T, U>>()
    private(set) var dictionary = [T: Node<CachePayload<T, U>>]()
    
    required init(capacity: UInt) {
        self.capacity = capacity
    }
    
    func setObject(for key: T, value: U) {
        let element = CachePayload(key: key, value: value)
        let node = Node(value: element)
        
        if let existingNode = dictionary[key] {
            linkedList.moveToHead(node: existingNode)
            linkedList.head?.payload.value = value
            dictionary[key] = node
        } else {
          if linkedList.count >= capacity {
                if let leastAccessedKey = linkedList.tail?.payload.key {
                  dictionary[leastAccessedKey] = nil
              }
              linkedList.remove()
          }
            linkedList.insert(node: node, at: 0)
            dictionary[key] = node
        }
    }
    
    func retrieveObject(at key: T) -> U? {
        guard let existingNode = dictionary[key] else { return nil }
        linkedList.moveToHead(node: existingNode)
        return existingNode.payload.value
    }
    
    func removeAll() {
        linkedList.remove()
        dictionary.removeAll()
    }
}
