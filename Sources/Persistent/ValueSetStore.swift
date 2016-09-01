//
//  ValueSetStore.swift
//
//  Created by XiaoshaQuan on 1/28/16.
//

import Foundation
import FMDB

// Current only support String value, sinle coloum database

public class ValueSetStore: NSObject {
    
    private static let sharedQueue = dispatch_queue_create("com.qiudao.baomingba.valuesetstore.queue", DISPATCH_QUEUE_SERIAL)
    
    private var _database : FMDatabase
    
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
    
    public func insert(value: String) {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("REPLACE INTO valueset (value) values (?)", withArgumentsInArray: [value])
            
            if !result {
                print("fail to store value: \(value)")
            }
        }
    }
    
    public func remove(value: String) {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("DELETE FROM valueset WHERE value = ?", withArgumentsInArray: [value])
            
            if !result {
                print("fail to remove value: \(value)")
            }
        }
    }
    
    public func contains(value: String) -> Bool {
        
        var result: Bool = false
        
        sync { () -> Void in
            
            let resultSet = self._database.executeQuery("SELECT * FROM valueset WHERE value = ?", withArgumentsInArray: [value])
            
            result = resultSet.next()
            
            resultSet.close()
        }
        
        return result
    }
    
    public func allValues() -> Set<String> {
        
        var valueset = Set<String>()
        
        sync { () -> Void in
            
            let result = self._database.executeQuery("SELECT * FROM valueset", withArgumentsInArray: [])
            
            while result.next() {
                if let value = result.stringForColumn("value") {
                    valueset.insert(value)
                }
                else {
                    assertionFailure("fail to parse value")
                }
            }
            result.close()
        }
        
        return valueset
    }
    
    public func removeAllValues() {
        
        async { () -> Void in
            
            let result = self._database.executeUpdate("DELETE FROM valueset", withArgumentsInArray: [])
            
            if !result {
                print("fail to remove valueset")
            }
        }
    }
    
    private func sync(block: () -> Void) {
        dispatch_sync(ValueSetStore.sharedQueue, block)
    }
    
    private func async(block: () -> Void ) {
        dispatch_async(ValueSetStore.sharedQueue, block)
    }
}


