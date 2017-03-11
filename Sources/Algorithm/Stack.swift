//
//  Stack.swift
//
//  Created by XiaoshaQuan on 12/18/15.
//


open class Stack<T> {
    
    fileprivate var _dlist: DList<T> = DList<T>()
    
    open var count: Int {
        return _dlist.count
    }
    
    public init() {
        
    }
    
    open func isEmpty() -> Bool {
        return _dlist.head == nil
    }
    
    open func top() -> T? {
        return _dlist.head?.data
    }
    
    open func push(_ value: T) {
        _dlist.insertNode(DListNode(data: value))
    }
    
    open func pop() {
        if let head = _dlist.head {
            _dlist.removeNode(head)
        }
    }
    
}

