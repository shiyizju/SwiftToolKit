//
//  Queue.swift
//  baomingba
//
//  Created by XiaoshaQuan on 11/30/15.
//  Copyright © 2015 杭州求道网络科技有限公司. All rights reserved.
//


public class Queue<T> {
    
    private var _dlist: DList<T> = DList<T>()
    
    public init() {
        
    }
    
    public var count: Int {
        return _dlist.count
    }
    
    public func isEmpty() -> Bool {
        return _dlist.head == nil
    }
    
    public func front() -> T? {
        return _dlist.head?.data
    }
    
    public func back() -> T? {
        return _dlist.tail?.data
    }
    
    public func enqueue(value: T) {
        _dlist.appendNode(DListNode(data: value))
    }
    
    public func dequeue() {
        if let head = _dlist.head {
            _dlist.removeNode(head)
        }
    }
}

