//
//  CachedBiMap.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

import Foundation


// currently key must be string

public class CachedBiMap<V: Hashable> {
    
    private var _store : KeyValueStore<V>?
    private var _cache : BiMap<String, V>
    
    public init(path: String) {
        _store = KeyValueStore(path: path)
        if let store = _store {
            _cache = BiMap(dictionary: store.allKeyValues())
        } else {
            _cache = BiMap()
        }
    }
    
    public func valueForKey(key: String) -> V? {
        return _cache.valueForKey(key)
    }
    
    public func keyForValue(value: V) -> String? {
        return _cache.keyForValue(value)
    }
    
    public func setValue(value: V, forKey key: String) {
        _cache.setValue(value, forKey: key)
        _store?.setValue(value, forKey: key)
    }
    
    public func removeKey(key: String) {
        _cache.removeKey(key)
        _store?.removeValueForKey(key)
    }
    
    public func removeValue(value: V) {
        if let key = keyForValue(value) {
            removeKey(key)
        }
    }
    
    public func removeAll() {
        _cache.removeAll()
        _store?.removeAllValues()
    }
    
}




