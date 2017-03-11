//
//  CachedArray.swift
//
//  Created by XiaoshaQuan on 3/31/16.
//

open class CachedArray<T> {
    
    fileprivate var _cache : [T]
    fileprivate var _store : KeyValueStore<T>?
    
    public init(path: String) {
        _store = KeyValueStore(path: path)
        
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
                return kv.1
            })
            
            var needsRepair: Bool = false
            for i in 0..<orderedKvPair.count {
                if orderedKvPair[i].0 != "\(i)" {
                    needsRepair = true
                    assertionFailure()  // crash if debug
                    break
                }
            }
            
            if needsRepair {
                store.removeAllValues()
                for i in 0..<_cache.count {
                    store.setValue(_cache[i], forKey: "\(i)")
                }
            }
        }
        else {
            _cache = []
        }
    }
    
    open func append(_ object: T) {
        _store?.setValue(object, forKey: "\(_cache.count)")
        _cache.append(object)
    }
    
    open func objectAtIndex(_ index: Int) -> T {
        return _cache[index]
    }
    
    open func setObjectAtIndex(_ index: Int, object: T) {
        _store?.setValue(object, forKey: "\(_cache.count)")
        _cache[index] = object
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

