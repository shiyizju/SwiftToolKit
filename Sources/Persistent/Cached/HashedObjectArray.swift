//
//  HashedObjectArray.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

import Foundation

// key must be string

public class HashedObjectArray<T:SerializableObject> {
    
    private var _keyIndexMap : CachedBiMap<Int>
    private var _objectArray : CachedObjectArray<T>
    
    
    private func key2Index(key: String) -> Int? {
        return _keyIndexMap.valueForKey(key)
    }
    
    
    public init(path: String, builder: () -> T) {
        _keyIndexMap = CachedBiMap(path: path + "_keyIndexMap")
        _objectArray = CachedObjectArray(path: path + "_objectArray", builder: builder)
    }
    
    public func append(object: T, forKey key: String) {
        
        if let index = key2Index(key) {
            _objectArray.updateObjectAtIndex(index, json: object.convertToDictionary())
            assertionFailure("object of key:\(key) already exists")
        }
        else {
            let index = _objectArray.size
            _objectArray.append(object)
            _keyIndexMap.setValue(index, forKey: key)
        }
    }
    
    public func appendJson(json: Json, forKey key: String) {
        
        if let index = key2Index(key) {
            _objectArray.updateObjectAtIndex(index, json: json)
            //assertionFailure("object of key:\(key) already exists")
        }
        else {
            let index = _objectArray.size
            _objectArray.appendJson(json)
            _keyIndexMap.setValue(index, forKey: key)
        }
    }
    
    public func objectAtIndex(index: Int) -> T {
        return _objectArray.objectAtIndex(index)
    }
    
    public func objectForKey(key: String) -> T? {
        if let index = key2Index(key) {
            return _objectArray.objectAtIndex(index)
        }
        
        return nil
    }
    
    public func updateObjectAtIndex(index: Int, json: Json) {
        _objectArray.updateObjectAtIndex(index, json: json)
    }
    
    public func updateObjectForKey(key: String, json: Json) {
        if let index = key2Index(key) {
            _objectArray.updateObjectAtIndex(index, json: json)
        }
    }
    
    // all object in order
    public func allObjects() -> [T] {
        return _objectArray.allObjects()
    }
    
    public func removeAllObjects() {
        _keyIndexMap.removeAll()
        _objectArray.removeAllObjects()
    }

}


