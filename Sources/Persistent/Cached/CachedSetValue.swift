//
//  CachedSetValueStore.swift
//  baomingba
//
//  Created by XiaoshaQuan on 1/28/16.
//  Copyright © 2016 杭州求道网络科技有限公司. All rights reserved.
//

import Foundation


// have a in-memory copy of value set, currently only support string

public class CachedValueSet {
    
    private var _store : ValueSetStore?
    private var _cache : Set<String>
    
    public var count : Int {
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
    
    public func insert(value: String) {
        _cache.insert(value)
        _store?.insert(value)
    }
    
    public func remove(value: String) {
        _cache.remove(value)
        _store?.remove(value)
    }
    
    public func contains(value: String) -> Bool {
        return _cache.contains(value)
    }
    
    public func allValues() -> Set<String> {
        return _cache
    }
    
    public func removeAllValues() {
        _cache.removeAll(keepCapacity: true)
        _store?.removeAllValues()
    }
}





