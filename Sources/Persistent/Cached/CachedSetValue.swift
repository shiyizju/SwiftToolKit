//
//  CachedSetValueStore.swift
//
//  Created by XiaoshaQuan on 1/28/16.
//

import Foundation


// have a in-memory copy of value set, currently only support string

open class CachedValueSet {
    
    fileprivate var _store : ValueSetStore?
    fileprivate var _cache : Set<String>
    
    open var count : Int {
        return _cache.count
    }
    
    public init(path: String) {
        
        if let store = ValueSetStore(path: path) {
            _store = store
            _cache = store.allValues()
        }
        else {
            _cache = Set<String>()
        }
    }
    
    public init(store: ValueSetStore?) {
        if store != nil {
            _store = store
            _cache = store!.allValues()
        }
        else {
            _cache = Set<String>()
        }
    }
    
    open func insert(_ value: String) {
        _cache.insert(value)
        _store?.insert(value)
    }
    
    open func remove(_ value: String) {
        _cache.remove(value)
        _store?.remove(value)
    }
    
    open func contains(_ value: String) -> Bool {
        return _cache.contains(value)
    }
    
    open func allValues() -> Set<String> {
        return _cache
    }
    
    open func removeAllValues() {
        _cache.removeAll(keepingCapacity: true)
        _store?.removeAllValues()
    }
}





