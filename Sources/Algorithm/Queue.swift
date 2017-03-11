//
//  Queue.swift
//
//  Created by XiaoshaQuan on 11/30/15.
//


open class Queue<T> {
    
    fileprivate var _dlist: DList<T> = DList<T>()
    
    public init() {
        
    }
    
    open var count: Int {
        return _dlist.count
    }
    
    open var isEmpty: Bool {
        return _dlist.head == nil
    }
    
    open func front() -> T? {
        return _dlist.head?.data
    }
    
    open func back() -> T? {
        return _dlist.tail?.data
    }
    
    open func enqueue(_ value: T) {
        _dlist.appendNode(DListNode(data: value))
    }
    
    open func dequeue() {
        if let head = _dlist.head {
            _dlist.removeNode(head)
        }
    }
}


