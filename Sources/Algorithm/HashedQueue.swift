//
//  IndexedQueue.swift
//  baomingba
//
//  Created by XiaoshaQuan on 12/9/15.
//


// K: index type
// V: value type

public class HashedQueue<K: Hashable, V> {
    
    private typealias T = (K, V)
    
    private var _map: [K: DListNode<T>] = [:]
    private var _dlist: DList<T> = DList<T>()
    
    public init() {
        
    }
    
    public func isEmpty() -> Bool {
        return _dlist.head == nil
    }
    
    public func front() -> (K, V)? {
        return _dlist.head?.data
    }
    
    public func back() -> (K, V)? {
        return _dlist.tail?.data
    }
    
    public func enqueue(keyValuePair: (K, V)) {
        
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
    
    public func dequeue() {
        
        if let head = _dlist.head {
            _dlist.removeNode(head)
            _map.removeValueForKey(head.data.0)
        }
    }
    
    public func removeAll() {
        while !isEmpty() {
            dequeue()
        }
    }
    
    // all values in order
    public func allKeyValues() -> [(K, V)] {
        return _dlist.allValues()
    }
    
    public func getValueForKey(key: K) -> V? {
        
        guard let node = _map[key] else {
            return nil
        }
        
        return node.data.1
    }
    
    public func removeValueForKey(key: K) {
        
        guard let node = _map[key] else {
            return
        }
        
        _dlist.removeNode(node)
        _map.removeValueForKey(key)
    }
}
