//
//  CachedKeyValueStore.swift
//
//  Created by XiaoshaQuan on 1/28/16.
//

import Foundation


// have a in-memory copy of key value

public class CachedKeyValueStore<ValueType> {
    
    private var _store : KeyValueStore<ValueType>
    private var _cache : [String: ValueType] = [:]
    
    public init(path: String) {
        _store = KeyValueStore(path: path)
        _cache = _store.allKeyValues()
    }
    
    public func setValue(value: ValueType, forKey key: String) {
        _cache[key] = value
        _store.setValue(value, forKey: key)
    }
    
    public func valueForKey(key: String) -> ValueType? {
        return _cache[key]
    }
    
    public func allValues() -> [ValueType] {
        return Array(_cache.values)
    }
    
    public func allKeyValues() -> [String: ValueType] {
        return _cache
    }
    
    public func removeValueForKey(key: String) {
        _cache.removeValueForKey(key)
        _store.removeValueForKey(key)
    }
    
    public func removeAllValues() {
        _cache.removeAll(keepCapacity: true)
        _store.removeAllValues()
    }
    
}
