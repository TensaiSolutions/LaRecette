//
//  DoubleLinkedList.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

public protocol Payload {
    associatedtype Key
    associatedtype Value
    
    var key: Key { get set }
    var value: Value { get set }
}


struct CachePayload<T: Hashable, U>: Payload {
    public var key: T
    public var value: U
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

class Node<T: Payload> {
    var payload: T
    var previous: Node<T>?
    var next: Node<T>?
    
    init(value: T) {
        self.payload = value
    }
}

class DoubleLinkedList<T: Payload> {
    var head: Node<T>?
    var tail: Node<T>?
    
    var isEmpty: Bool {
        return head == nil && tail == nil
    }
    
    var count: Int = 0
    
    init() { }
    
    func node(at index: Int) -> Node<T>? {
        guard !isEmpty || index == 0 else{
            return head
        }
        
        var node = head
        for _ in stride(from: 0, to: index, by: 1) {
            node = node?.next
        }
        
        return node
    }
    
    func add(value: T) {
        let node = Node(value: value)
        
        guard !isEmpty else {
            head = node
            tail = node
            count += 1
            return
        }
        
        node.previous = tail
        tail?.next = node
        tail = node
        count += 1
    }
    
    @discardableResult
    func insert(value: T, at index: Int) -> Bool {
        guard !isEmpty else {
            add(value: value)
            return true
        }
        
        guard case 0..<count = index else {
            print("NOT WITHIN HERE")
            return false
        }
        
        let newNode = Node(value: value)
        
        var currNode = head
        for _ in stride(from: 0, to: index - 1, by: 1) {
            currNode = currNode?.next
        }
        
        if currNode === head {
            if head === tail {
                newNode.next = head
                head?.previous = newNode
                head = newNode
            } else {
                newNode.next = head
                head = newNode
            }
            
            count += 1
            return true
        }
        
        newNode.previous = currNode
        newNode.next = currNode?.next
        currNode?.next?.previous = newNode
        currNode?.next = newNode
        
        count += 1
        return true
    }
    
    @discardableResult
    public func insert(node: Node<T>, at index: Int) -> Bool {
        guard !isEmpty else {
            head = node
            tail = node
            count += 1
            return true
        }
        
        guard case 0..<count = index else {
            return false
        }
        
        var currNode = head
        for _ in stride(from: 0, to: index - 1, by: 1) {
            currNode = currNode?.next
        }
        
        if currNode === head {
            if head === tail {
                node.next = head
                head?.previous = node
                head = node
            } else {
                node.next = head
                head = node
            }
            
            count += 1
            return true
        }
        
        node.previous = currNode
        node.next = currNode?.next
        currNode?.next?.previous = node
        currNode?.next = node
        
        count += 1
        return true
    }
    @discardableResult
    func remove(at index: Int) -> Bool {
        guard case 0..<count = index else {
            return false
        }
        
        var currNode = head
        for _ in stride(from: 0, to: index, by: 1) {
            currNode = currNode?.next
        }
        
        if currNode === head {
            if head === tail {
                head = nil
                tail = nil
            } else {
                head?.next?.previous = nil
                head = head?.next
            }
            count -= 1
            return true
        }
        
        currNode?.previous?.next = currNode?.next
        currNode?.next?.previous = currNode?.previous
        
        count -= 1
        return true
    }
    
    @discardableResult
    public func remove() -> Bool {
        guard !isEmpty else {
            return false
        }
        
        if head === tail {
            head = nil
            tail = nil
            count -= 1
            return true
        }
        
        tail?.previous?.next = nil
        tail = tail?.previous
        
        count -= 1
        return true
    }
    
    public func moveToHead(node: Node<T>) {
        guard !isEmpty else {
            return
        }
        
        if head === node && tail === node {
            // do nothing
        } else if head === node {
            // do nothing
        } else if tail === node {
            tail?.previous?.next = nil
            tail = tail?.previous
            
            let prevHead = head
            head?.next?.previous = node
            head = node
            head?.next = prevHead
        } else {
            var currNode = head
            while currNode?.next !== node && currNode !== tail {
                currNode = currNode?.next
            }
            
            currNode?.next = node.next
            node.next?.previous = currNode
            
            let prevHead = head
            head = node
            head?.next = prevHead
            prevHead?.previous = head
        }
    }
}
