//
//  Stack.swift
//  baomingba
//
//  Created by XiaoshaQuan on 12/18/15.
//  Copyright © 2015 杭州求道网络科技有限公司. All rights reserved.
//


public class Stack<T> {
    
    private var _dlist: DList<T> = DList<T>()
    
    public var count: Int {
        return _dlist.count
    }
    
    public init() {
        
    }
    
    public func isEmpty() -> Bool {
        return _dlist.head == nil
    }
    
    public func top() -> T? {
        return _dlist.head?.data
    }
    
    public func push(value: T) {
        _dlist.insertNode(DListNode(data: value))
    }
    
    public func pop() {
        if let head = _dlist.head {
            _dlist.removeNode(head)
        }
    }
    
}

