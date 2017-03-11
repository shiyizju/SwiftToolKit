//
//  CachedKeyValueStore.swift
//
//  Created by XiaoshaQuan on 1/28/16.
//

import Foundation


// have a in-memory copy of key value

open class CachedKeyValueStore<ValueType> {
    
    fileprivate var _store : KeyValueStore<ValueType>
    fileprivate var _cache : [String: ValueType] = [:]
    
    public init(path: String) {
        _store = KeyValueStore(path: path)
        _cache = _store.allKeyValues()
    }
    
    open func setValue(_ value: ValueType, forKey key: String) {
        _cache[key] = value
        _store.setValue(value, forKey: key)
    }
    
    open func valueForKey(_ key: String) -> ValueType? {
        return _cache[key]
    }
    
    open func allValues() -> [ValueType] {
        return Array(_cache.values)
    }
    
    open func allKeyValues() -> [String: ValueType] {
        return _cache
    }
    
    open func removeValueForKey(_ key: String) {
        _cache.removeValue(forKey: key)
        _store.removeValueForKey(key)
    }
    
    open func removeAllValues() {
        _cache.removeAll(keepingCapacity: true)
        _store.removeAllValues()
    }
    
}
