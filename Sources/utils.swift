//
//  JsonUtils.swift
//
//  Created by XiaoshaQuan on 12/17/15.
//

import Foundation


public typealias Json = [String: Any]
public typealias JsonArray = [Json]


// JsonType usually is [String: AnyObject] or [[String: AnyObject]]
public func jsonString2jsonObject<JsonType>(_ jsonString: String) -> JsonType? {
    
    var jsonObject: JsonType? = nil
    
    if let jsonData = jsonString.data(using: String.Encoding.utf8) {
        do {
            jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JsonType
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    
    return jsonObject
}


// JsonType usually is [String: AnyObject] or [[String: AnyObject]]
public func jsonObject2jsonString<JsonType>(_ jsonObject: JsonType) -> String? {
    
    var jsonString : String? = nil
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String
    }
    catch let error as NSError {
        print(error.description)
    }
    
    return jsonString
}



extension Dictionary {
    
    internal func map<K: Hashable, V>(_ f: (Element) -> (K, V)) -> [K : V] {
        var mapped = [K : V]()
        
        for element in self {
            let newElement = f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    internal func map<K: Hashable, V>(_ f: (Element) -> (K, [V])) -> [K : [V]] {
        var mapped = [K : [V]]()
        
        for element in self {
            let newElement = f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    
    internal func filterMap<U>(_ f: (Value) -> U?) -> [Key : U] {
        var mapped = [Key : U]()
        
        for (key, value) in self {
            if let newValue = f(value){
                mapped[key] = newValue
            }
        }
        
        return mapped
    }
}
