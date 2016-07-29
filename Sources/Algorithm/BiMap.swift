//
//  BidirectionalMap.swift
//  baomingba
//
//  Created by XiaoshaQuan on 10/21/15.
//


// https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/BidiMap.html


// This class is not thread safe

public class BiMap<KeyType: Hashable, ValueType: Hashable> {
    
    public init() {
        
    }
    
    public init(dictionary: [KeyType: ValueType]) {
        for (key, value) in dictionary {
            setValue(value, forKey: key)
        }
    }
    
    private var _map: [KeyType: ValueType] = [:]
    public var keyValueMap: [KeyType: ValueType] {
        return _map
    }
    
    private var _reverseMap: [ValueType: KeyType]   = [:]
    public var valueKeyMap: [ValueType: KeyType] {
        return _reverseMap
    }
    
    public func valueForKey(key: KeyType) -> ValueType? {
        return _map[key]
    }
    
    public func keyForValue(value: ValueType) -> KeyType? {
        return _reverseMap[value]
    }
    
    public func setValue(value: ValueType, forKey key: KeyType) {
        
        if let oldValue = _map[key] {
            _reverseMap.removeValueForKey(oldValue)
        }
        
        _map[key] = value
        _reverseMap[value] = key
    }
    
    public func addDictionary(dict: [KeyType: ValueType]) {
        for (key, value) in dict {
            setValue(value, forKey: key)
        }
    }
    
    public func removeKey(key: KeyType) {
        
        if let value = _map[key] {
            _map.removeValueForKey(key)
            _reverseMap.removeValueForKey(value)
        }
    }
    
    public func removeValue(value: ValueType) {
        
        if let key = _reverseMap[value] {
            _reverseMap.removeValueForKey(value)
            _map.removeValueForKey(key)
        }
    }
    
    public func removeAll() {
        _map.removeAll()
        _reverseMap.removeAll()
    }
}



