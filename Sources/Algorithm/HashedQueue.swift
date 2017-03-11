//
//  IndexedQueue.swift
//
//  Created by XiaoshaQuan on 12/9/15.
//


// K: index type
// V: value type

open class HashedQueue<K: Hashable, V> {
    
    fileprivate typealias T = (K, V)
    
    fileprivate var _map: [K: DListNode<T>] = [:]
    fileprivate var _dlist: DList<T> = DList<T>()
    
    public init() {
        
    }
    
    open var count: Int {
        return _dlist.count
    }
    
    open func isEmpty() -> Bool {
        return _dlist.head == nil
    }
    
    open func front() -> (K, V)? {
        return _dlist.head?.data
    }
    
    open func back() -> (K, V)? {
        return _dlist.tail?.data
    }
    
    open func enqueue(_ keyValuePair: (K, V)) {
        
        let key = keyValuePair.0
        
        if _map[key] == nil {
            let node = DListNode(data: keyValuePair)
            
            _dlist.appendNode(node)
            _map.updateValue(node, forKey: key)
        }
        else {
            print("HashedQueue: \(keyValuePair) already exist")
        }
    }
    
    open func dequeue() {
        
        if let head = _dlist.head {
            _dlist.removeNode(head)
            _map.removeValue(forKey: head.data.0)
        }
    }
    
    open func removeAll() {
        while !isEmpty() {
            dequeue()
        }
    }
    
    // all values in order
    open func allKeyValues() -> [(K, V)] {
        return _dlist.allValues()
    }
    
    open func getValueForKey(_ key: K) -> V? {
        
        guard let node = _map[key] else {
            return nil
        }
        
        return node.data.1
    }
    
    open func removeValueForKey(_ key: K) {
        
        guard let node = _map[key] else {
            return
        }
        
        _dlist.removeNode(node)
        _map.removeValue(forKey: key)
    }
}
