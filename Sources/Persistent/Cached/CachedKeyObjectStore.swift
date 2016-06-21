//
//  CachedKeyObjectStore.swift
//  baomingba
//
//  Created by XiaoshaQuan on 3/28/16.
//  Copyright © 2016 杭州求道网络科技有限公司. All rights reserved.
//

import Foundation


public class CachedKeyObjectStore<ObjectType: SerializableObject> {
    
    private var _store : KeyValueStore<Json>
    private var _cache : [String: ObjectType] = [:]
    private var _builder: () -> ObjectType
    
    public init(path: String, objectBuilder builder: () -> ObjectType) {
        _store = KeyValueStore<Json>(path: path)
        _builder = builder
        
        // initialize objects
        let objectJsons : [String: Json] = _store.allKeyValues()
        _cache = objectJsons.map({ (key, json) -> (String, ObjectType) in
            let object = self._builder()
            object.restoreFromDictionary(json)
            return (key, object)
        })
    }
    
    private func transform(json: Json) -> ObjectType {
        let object = _builder()
        object.restoreFromDictionary(json)
        return object
    }
    
    // will replace object
    public func setObject(object: ObjectType, forKey key: String) {
        _cache[key] = object
        _store.setValue(object.convertToDictionary(), forKey: key)
    }
    
    // create if not exist, otherwise update
    public func setJson(json: Json, forKey key: String) {
        if let object = _cache[key] {
            object.restoreFromDictionary(json)
            _store.setValue(object.convertToDictionary(), forKey: key)
        }
        else {
            _cache[key] = transform(json)
            _store.setValue(json, forKey: key)
        }
    }
    
    // update if exist
    public func updateObject(json: Json, forKey key: String) {
        if let object = _cache[key] {
            object.restoreFromDictionary(json)
            _store.setValue(object.convertToDictionary(), forKey: key)
        }
    }
    
    public func objectForKey(key: String) -> ObjectType? {
        return _cache[key]
    }
    
    public func allObjects() -> [ObjectType] {
        return Array(_cache.values)
    }
    
    public func allKeyObjects() -> [String: ObjectType] {
        return _cache
    }
    
    public func removeObjectForKey(key: String) {
        _cache.removeValueForKey(key)
        _store.removeValueForKey(key)
    }
    
    public func removeAllObjects() {
        _cache.removeAll(keepCapacity: true)
        _store.removeAllValues()
    }
}


