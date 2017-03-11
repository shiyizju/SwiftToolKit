//
//  HashedObjectArray.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

import Foundation


// base on CachedObjectArray, add key index map.

open class HashedObjectArray<T:SerializableObject> {
    
    private var _keyIndexMap : CachedBiMap<Int>
    private var _objectArray : CachedObjectArray<T>
    
    private func key2Index(_ key: String) -> Int? {
        return _keyIndexMap.valueForKey(key)
    }
    
    public init(path: String, builder: @escaping () -> T) {
        _keyIndexMap = CachedBiMap(path: path + "_keyIndexMap")
        _objectArray = CachedObjectArray(path: path + "_objectArray", builder: builder)
    }
    
    open func append(_ object: T, forKey key: String) {
        
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
    
    open func appendJson(_ json: Json, forKey key: String) {
        
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
    
    open func objectAtIndex(_ index: Int) -> T {
        return _objectArray.objectAtIndex(index)
    }
    
    open func objectForKey(_ key: String) -> T? {
        if let index = key2Index(key) {
            return _objectArray.objectAtIndex(index)
        }
        
        return nil
    }
    
    open func updateObjectAtIndex(_ index: Int, json: Json) {
        _objectArray.updateObjectAtIndex(index, json: json)
    }
    
    open func updateObjectForKey(_ key: String, json: Json) {
        if let index = key2Index(key) {
            _objectArray.updateObjectAtIndex(index, json: json)
        }
    }
    
    // all object in order
    open func allObjects() -> [T] {
        return _objectArray.allObjects()
    }
    
    open func removeAllObjects() {
        _keyIndexMap.removeAll()
        _objectArray.removeAllObjects()
    }

}


