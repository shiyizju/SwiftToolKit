//
//  KeyValueStore.swift
//
//  Created by XiaoshaQuan on 4/1/16.
//

import Foundation
import FMDB

// Supporting type: Int, String, Json type (can be converted to json use NSJSONSErialization)

private let sharedQueue = DispatchQueue(label: "com.qiudao.baomingba.keyvaluestore.queue", attributes: [])


open class KeyValueStore<T> {
    
    fileprivate var _database : FMDatabase
    
    public init(path: String) {
        
        _database = FMDatabase(path: path)
        
        guard _database.open() else {
            assertionFailure("fail to create key value store of path: \(path)")
            return
        }
        
        guard _database.executeStatements("CREATE TABLE IF NOT EXISTS 'bmb_table' ('bmb_key' TEXT PRIMARY KEY,'bmb_value' TEXT)") else {
            assertionFailure("fail to create key values store of path: \(path)")
            return
        }
        
    }
    
    deinit {
        _database.close()
    }
    
    open func setValue(_ value: T, forKey key: String) {
        
        guard let stringValue = value2String(value) else {
            return
        }
    
        async {
            if !self._database.executeUpdate("REPLACE INTO bmb_table (bmb_key,bmb_value) values (?,?)", withArgumentsIn: [key, stringValue]) {
                print("fail to store object of key: \(key)")
            }
        }
    }
    
    open func removeValueForKey(_ key: String) {
        async {
            if !self._database.executeUpdate("DELETE FROM bmb_table WHERE bmb_key = ?", withArgumentsIn: [key]) {
                print("fail to remove object with key \(key)")
            }
        }
    }
    
    open func valueForKey(_ key: String) -> T? {
        
        var result: String? = nil
        
        sync {
            let rs = self._database.executeQuery("SELECT * FROM bmb_table WHERE bmb_key = ?", withArgumentsIn: [key])
            if (rs?.next())! {
                result = rs?.string(forColumn: "bmb_value")
            }
            else {
                print("fail to get value for key \(key)")
            }
            rs?.close()
        }
        
        if let stringValue = result {
            return string2Value(stringValue)
        }
        
        return nil
    }
    
    
    open func allValues() -> [T] {
        
        var results : [String] = []
        
        sync {
            let rs = self._database.executeQuery("SELECT * FROM bmb_table", withArgumentsIn: [])
            while (rs?.next())! {
                if let object = rs?.string(forColumn: "bmb_value") {
                    results.append(object)
                }
            }
            rs?.close()
        }
        
        return results.flatMap({ (stringValue) -> T? in
            return self.string2Value(stringValue)
        })
    }
    
    
    open func allKeyValues() -> [String: T] {
        
        var results : [String: String] = [:]
        
        sync {
            let rs = self._database.executeQuery("SELECT * FROM bmb_table", withArgumentsIn: [])
            while (rs?.next())! {
                if let key = rs?.string(forColumn: "bmb_key"), let object = rs?.string(forColumn: "bmb_value") {
                    results[key] = object
                }
            }
            rs?.close()
        }
        
        return results.filterMap({ (stringValue) -> T? in
            return self.string2Value(stringValue)
        })
    }
    
    
    open func removeAllValues() {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("DELETE FROM bmb_table", withArgumentsIn: [])
            
            if !result {
                print("fail to remove all objects")
            }
        }
    }
    
    
    fileprivate func value2String(_ value: T) -> String? {
        
        if let stringValue = value as? String {
            return stringValue
        }
        else if let intValue = value as? Int {
            return String(intValue)
        }
        else if let intValue = value as? Int64 {
            return String(intValue)
        }
        else if let jsonString = jsonObject2jsonString(value) {
            return jsonString
        }
        assertionFailure()
        return nil
    }
    
    fileprivate func string2Value(_ string: String) -> T? {
        
        if let value = string as? T {
            return value
        }
        else if let value = Int(string) as? T {
            return value
        }
        else if let value: T = jsonString2jsonObject(string) {
            return value
        }
        assertionFailure()
        return nil
    }
    
    
    fileprivate func sync(_ block: () -> Void) {
        sharedQueue.sync(execute: block)
    }
    
    fileprivate func async(_ block: @escaping () -> Void ) {
        sharedQueue.async(execute: block)
    }
    
}











