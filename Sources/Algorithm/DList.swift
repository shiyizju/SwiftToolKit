//
//  DList.swift
//
//  Created by XiaoshaQuan on 11/30/15.
//


// Double linked list

internal class DListNode<T> {
    
    var data: T
    
    // Set this property to weak will lead to crash in iOS 7.
    // Workaround, break strong reference in DList deinit.
    var prev: DListNode<T>?
    
    var next: DListNode<T>?
    
    init(data: T, prev: DListNode? = nil, next: DListNode? = nil) {
        self.data = data
        self.prev = prev
        self.next = next
    }
}



internal class DList<T> {
    
    private var _head: DListNode<T>?
    private var _tail: DListNode<T>?
    private(set) var count: Int = 0
    
    var head: DListNode<T>? {
        return _head
    }
    
    var tail: DListNode<T>? {
        return _tail
    }
    
    // node must be in the list
    func removeNode(node: DListNode<T>) {
        
        if node.prev == nil {   // head
            _head = node.next
        } else {
            node.prev!.next = node.next
        }
        
        if node.next == nil {   // tail
            _tail = node.prev
        } else {
            node.next!.prev = node.prev
        }
        
        count -= 1
    }
    
    // insert node at head. node must not in the list.
    func insertNode(node: DListNode<T>) {
        
        if _head == nil {        // list is empty
            _head = node
            _tail = node
            node.prev = nil
            node.next = nil
        }
        else {                  // insert at head
            _head!.prev = node
            node.next = _head
            node.prev = nil
            _head = node
        }
        
        count += 1
    }
    
    // insert node at tail. node must not in the list.
    func appendNode(node: DListNode<T>) {
        
        if _head == nil {       // list is empty
            _head = node
            _tail = node
            node.prev = nil
            node.next = nil
        }
        else {                  // insert at tail
            _tail!.next = node
            node.prev = _tail
            node.next = nil
            _tail = node
        }
        
        count += 1
    }
    
    // all values in order
    func allValues() -> [T] {
        
        var values:[T] = []
        
        var node = head
        while node != nil {
            values.append(node!.data)
            node = node!.next
        }
        
        assert(count == values.count)
        
        return values
    }

    deinit {
        // break cycle reference
        var node = _head
        while node != nil {
            node!.prev = nil
            node = node!.next
        }
    }
}



