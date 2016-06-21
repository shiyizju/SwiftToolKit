//
//  JsonUtils.swift
//  baomingba
//
//  Created by XiaoshaQuan on 12/17/15.
//  Copyright © 2015 杭州求道网络科技有限公司. All rights reserved.
//

import Foundation


public typealias Json = [String: AnyObject]
public typealias JsonArray = [Json]


// JsonType usually is [String: AnyObject] or [[String: AnyObject]]
public func jsonString2jsonObject<JsonType>(jsonString: String) -> JsonType? {
    
    var jsonObject: JsonType? = nil
    
    if let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? JsonType
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    
    return jsonObject
}


// JsonType usually is [String: AnyObject] or [[String: AnyObject]]
public func jsonObject2jsonString<JsonType>(jsonObject: JsonType) -> String? {
    
    var jsonString : String? = nil
    
    if let obj = jsonObject as? AnyObject {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(obj, options: [])
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as? String
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    
    return jsonString
}



extension Dictionary {
    
    internal func map<K: Hashable, V>(@noescape f: Element -> (K, V)) -> [K : V] {
        var mapped = [K : V]()
        
        for element in self {
            let newElement = f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    internal func map<K: Hashable, V>(@noescape f: Element -> (K, [V])) -> [K : [V]] {
        var mapped = [K : [V]]()
        
        for element in self {
            let newElement = f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    
    internal func filterMap<U>(@noescape f: Value -> U?) -> [Key : U] {
        var mapped = [Key : U]()
        
        for (key, value) in self {
            if let newValue = f(value){
                mapped[key] = newValue
            }
        }
        
        return mapped
    }
}
