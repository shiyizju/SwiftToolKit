//
//  LRUCache.swift
//
//  Created by XiaoshaQuan on 11/5/15.
//


// Latest recent used cache


public class LRUCache<K: Hashable, V> {
    
    private var _capacity: Int
    private var _map: [K: DListNode<(K, V)>] = [:]
    private var _dlist: DList<(K, V)> = DList()
    
    public init(capacity: Int) {
        _capacity = capacity
    }
    
    // all key values in order
    public func allKeyValues() -> [(K, V)] {
        return _dlist.allValues()
    }
    
    // all values in order
    public func allValues() -> [V] {
        var values: [V] = []
        for (_, value) in _dlist.allValues() {
            values.append(value)
        }
        return values
    }
    
    public func getValueForKey(key: K) -> V? {
        
        if _capacity == 0 {
            return nil
        }
        
        guard let node = _map[key] else {
            return nil
        }
        
        if node !== _dlist.head! {
            _dlist.removeNode(node)
            _dlist.insertNode(node)
        }
        
        return node.data.1
    }
    
    public func setValue(value: V, forKey key: K) {
        
        if _capacity == 0 {
            return
        }
        
        // find in cache
        if let node = _map[key] {
            node.data = (key, value)
            if node !== _dlist.head {
                _dlist.removeNode(node)
                _dlist.insertNode(node)
            }
        }
        else if _map.count == _capacity {
            let node = _dlist.tail!
            
            _map.removeValueForKey(node.data.0)
            _dlist.removeNode(node)
            
            node.data = (key, value)
            
            _dlist.insertNode(node)
            _map[key] = node
        }
        else {
            
            let node = DListNode(data: (key, value))
            
            _dlist.insertNode(node)
            _map[key] = node
        }
    }
}



