//
//  Queue.swift
//
//  Created by XiaoshaQuan on 11/30/15.
//


public class Queue<T> {
    
    private var _dlist: DList<T> = DList<T>()
    
    public init() {
        
    }
    
    public var count: Int {
        return _dlist.count
    }
    
    public var isEmpty: Bool {
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


