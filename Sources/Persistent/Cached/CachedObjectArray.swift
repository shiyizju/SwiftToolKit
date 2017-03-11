//
//  CachedObjectArray.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

import Foundation


// use key value to store array, index as key

open class CachedObjectArray<T:SerializableObject> {
    
    private var _cache : [T]
    private var _store : KeyValueStore<Json>?
    
    // object and json transformer
    private var json2Object: (Json) -> T
    private var object2Json: (T) -> Json
    
    open var size: Int {
        return _cache.count
    }
    
    public init(path: String, builder: @escaping () -> T) {
        _store = KeyValueStore(path: path)
        _cache = []
        
        json2Object = { json in
            var object = builder()
            object.restoreFromDictionary(json)
            return object
        }
        
        object2Json = { object in
            return object.convertToDictionary()
        }
        
        if let store = _store {
            
            let orderedKvPair = store.allKeyValues().sorted(by: { (kv0, kv1) -> Bool in
                // sort according to index
                if let index0 = Int(kv0.0), let index1 = Int(kv1.0) {
                    return index0 < index1
                }
                else {
                    assertionFailure()
                    return true
                }
            })
            
            _cache = orderedKvPair.map({ (kv) -> T in
                return json2Object(kv.1)
            })
            
            for i in 0..<orderedKvPair.count {
                if orderedKvPair[i].0 != "\(i)" {
                    
                    // crash if debug
                    assertionFailure()
                    
                    // repair store
                    store.removeAllValues()
                    for index in 0..<orderedKvPair.count {
                        store.setValue(orderedKvPair[i].1, forKey: "\(index)")
                    }
                    
                    break
                }
            }
        }
    }
    
    
    open func append(_ object: T) {
        _store?.setValue(object2Json(object), forKey: "\(_cache.count)")
        _cache.append(object)
    }
    
    open func appendJson(_ json: Json) {
        append(json2Object(json))
    }
    
    open func objectAtIndex(_ index: Int) -> T {
        return _cache[index]
    }
    
    open func updateObjectAtIndex(_ index: Int, json: Json) {
        var object = _cache[index]
        object.restoreFromDictionary(json)
        _store?.setValue(object2Json(object), forKey: "\(index)")
    }
    
    // all object in order
    open func allObjects() -> [T] {
        return _cache
    }
    
    open func removeAllObjects() {
        _cache.removeAll()
        _store?.removeAllValues()
    }
}


