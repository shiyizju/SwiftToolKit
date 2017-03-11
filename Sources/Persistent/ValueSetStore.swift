//
//  ValueSetStore.swift
//
//  Created by XiaoshaQuan on 1/28/16.
//

import Foundation
import FMDB

// Current only support String value, sinle coloum database

open class ValueSetStore: NSObject {
    
    fileprivate static let sharedQueue = DispatchQueue(label: "com.qiudao.baomingba.valuesetstore.queue", attributes: [])
    
    fileprivate var _database : FMDatabase
    
    public init?(path: String) {
        
        _database = FMDatabase(path: path)
        
        super.init()
        
        var result = _database.open()
        
        if result {
            let sql = "CREATE TABLE IF NOT EXISTS 'valueset' ('value' TEXT PRIMARY KEY)"
            result = _database.executeStatements(sql)
        }
        
        if !result {
            assertionFailure("fail to create value set store of path: \(path)")
            return nil
        }
    }
    
    deinit {
        _database.close()
    }
    
    open func insert(_ value: String) {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("REPLACE INTO valueset (value) values (?)", withArgumentsIn: [value])
            
            if !result {
                print("fail to store value: \(value)")
            }
        }
    }
    
    open func remove(_ value: String) {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("DELETE FROM valueset WHERE value = ?", withArgumentsIn: [value])
            
            if !result {
                print("fail to remove value: \(value)")
            }
        }
    }
    
    open func contains(_ value: String) -> Bool {
        
        var result: Bool = false
        
        sync { () -> Void in
            
            let resultSet = self._database.executeQuery("SELECT * FROM valueset WHERE value = ?", withArgumentsIn: [value])
            
            result = (resultSet?.next())!
            
            resultSet?.close()
        }
        
        return result
    }
    
    open func allValues() -> Set<String> {
        
        var valueset = Set<String>()
        
        sync { () -> Void in
            
            let result = self._database.executeQuery("SELECT * FROM valueset", withArgumentsIn: [])
            
            while (result?.next())! {
                if let value = result?.string(forColumn: "value") {
                    valueset.insert(value)
                }
                else {
                    assertionFailure("fail to parse value")
                }
            }
            result?.close()
        }
        
        return valueset
    }
    
    open func removeAllValues() {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("DELETE FROM valueset", withArgumentsIn: [])
            
            if !result {
                print("fail to remove valueset")
            }
        }
    }
    
    fileprivate func sync(_ block: () -> Void) {
        ValueSetStore.sharedQueue.sync(execute: block)
    }
    
    fileprivate func async(_ block: @escaping () -> Void ) {
        ValueSetStore.sharedQueue.async(execute: block)
    }
}


