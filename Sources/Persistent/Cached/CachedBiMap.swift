//
//  CachedBiMap.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

import Foundation


// currently key must be string

open class CachedBiMap<V: Hashable> {
    
    fileprivate var _store : KeyValueStore<V>?
    fileprivate var _cache : BiMap<String, V>
    
    public init(path: String) {
        _store = KeyValueStore(path: path)
        if let store = _store {
            _cache = BiMap(dictionary: store.allKeyValues())
        } else {
            _cache = BiMap()
        }
    }
    
    open func valueForKey(_ key: String) -> V? {
        return _cache.valueForKey(key)
    }
    
    open func keyForValue(_ value: V) -> String? {
        return _cache.keyForValue(value)
    }
    
    open func setValue(_ value: V, forKey key: String) {
        _cache.setValue(value, forKey: key)
        _store?.setValue(value, forKey: key)
    }
    
    open func removeKey(_ key: String) {
        _cache.removeKey(key)
        _store?.removeValueForKey(key)
    }
    
    open func removeValue(_ value: V) {
        if let key = keyForValue(value) {
            removeKey(key)
        }
    }
    
    open func removeAll() {
        _cache.removeAll()
        _store?.removeAllValues()
    }
    
}




