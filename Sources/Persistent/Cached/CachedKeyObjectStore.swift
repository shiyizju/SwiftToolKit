//
//  CachedKeyObjectStore.swift
//
//  Created by XiaoshaQuan on 3/28/16.
//

import Foundation


open class CachedKeyObjectStore<ObjectType: SerializableObject> {
    
    fileprivate var _store : KeyValueStore<Json>
    fileprivate var _cache : [String: ObjectType] = [:]
    fileprivate var _builder: () -> ObjectType
    
    open var count: Int {
        return _cache.count
    }
    
    public init(path: String, objectBuilder builder: @escaping () -> ObjectType) {
        _store = KeyValueStore<Json>(path: path)
        _builder = builder
        
        // initialize objects
        let objectJsons : [String: Json] = _store.allKeyValues()
        _cache = objectJsons.map({ (key, json) -> (String, ObjectType) in
            var object = self._builder()
            object.restoreFromDictionary(json)
            return (key, object)
        })
    }
    
    fileprivate func transform(_ json: Json) -> ObjectType {
        var object = _builder()
        object.restoreFromDictionary(json)
        return object
    }
    
    // will replace object
    open func setObject(_ object: ObjectType, forKey key: String) {
        _cache[key] = object
        _store.setValue(object.convertToDictionary(), forKey: key)
    }
    
    // create if not exist, otherwise update
    open func setJson(_ json: Json, forKey key: String) {
        if var object = _cache[key] {
            object.restoreFromDictionary(json)
            _store.setValue(object.convertToDictionary(), forKey: key)
        }
        else {
            _cache[key] = transform(json)
            _store.setValue(json, forKey: key)
        }
    }
    
    // update if exist
    open func updateObject(_ json: Json, forKey key: String) {
        if var object = _cache[key] {
            object.restoreFromDictionary(json)
            _store.setValue(object.convertToDictionary(), forKey: key)
        }
    }
    
    open func objectForKey(_ key: String) -> ObjectType? {
        return _cache[key]
    }
    
    open func allObjects() -> [ObjectType] {
        return Array(_cache.values)
    }
    
    open func allKeyObjects() -> [String: ObjectType] {
        return _cache
    }
    
    open func removeObjectForKey(_ key: String) {
        _cache.removeValue(forKey: key)
        _store.removeValueForKey(key)
    }
    
    open func removeAllObjects() {
        _cache.removeAll(keepingCapacity: true)
        _store.removeAllValues()
    }
}


