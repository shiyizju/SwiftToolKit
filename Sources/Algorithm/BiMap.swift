//
//  BidirectionalMap.swift
//
//  Created by XiaoshaQuan on 10/21/15.
//


// https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/BidiMap.html


// This class is not thread safe

open class BiMap<KeyType: Hashable, ValueType: Hashable> {
    
    public init() {
        
    }
    
    public init(dictionary: [KeyType: ValueType]) {
        for (key, value) in dictionary {
            setValue(value, forKey: key)
        }
    }
    
    fileprivate var _map: [KeyType: ValueType] = [:]
    open var keyValueMap: [KeyType: ValueType] {
        return _map
    }
    
    fileprivate var _reverseMap: [ValueType: KeyType]   = [:]
    open var valueKeyMap: [ValueType: KeyType] {
        return _reverseMap
    }
    
    open func valueForKey(_ key: KeyType) -> ValueType? {
        return _map[key]
    }
    
    open func keyForValue(_ value: ValueType) -> KeyType? {
        return _reverseMap[value]
    }
    
    open func setValue(_ value: ValueType, forKey key: KeyType) {
        
        // remove previous relation
        removeKey(key)
        removeValue(value)
        
        // create new relation
        _map[key] = value
        _reverseMap[value] = key
    }
    
    open func addDictionary(_ dict: [KeyType: ValueType]) {
        for (key, value) in dict {
            setValue(value, forKey: key)
        }
    }
    
    open func removeKey(_ key: KeyType) {
        if let value = _map[key] {
            _map.removeValue(forKey: key)
            _reverseMap.removeValue(forKey: value)
        }
    }
    
    open func removeValue(_ value: ValueType) {
        if let key = _reverseMap[value] {
            _reverseMap.removeValue(forKey: value)
            _map.removeValue(forKey: key)
        }
    }
    
    open func removeAll() {
        _map.removeAll()
        _reverseMap.removeAll()
    }
}



