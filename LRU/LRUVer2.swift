//
//  LRUVer2.swift
//  ImageLRU
//
//  Created by Shubham Kamdi on 3/29/24.
//

import Foundation
public class LRUV2 {
    public static let shared = LRUV2()
    var capacity: Int = 0
    var head: Node?
    var count = 0
    var cache: [Int:Node] = [:]
    var tail: Node?

    public func set(_ capacity: Int) {
        self.capacity = capacity
    }
    
    public func get(_ key: Int) -> Int {
       if let node = cache[key] {
            moveToHead(node)
            return node.val
        } else {
            return -1
        }
    }
    
    public func put(_ key: Int, _ value: Int) {
        if let node = cache[key] {
            node.val = value
            moveToHead(node)
        } else {
            let node = Node(key, value)
            
            node.next = head
            head?.prev = node
            head = node
            cache[key] = node
            count += 1
            if tail == nil {
                tail = head
            }
        }
        if count > capacity {
            cache.removeValue(forKey: tail!.key)
            tail = tail?.prev
            tail?.next = nil
            count -= 1
        }
    }

    func moveToHead(_ node: Node) {
       if node === head {
           return
       } else {
           node.prev?.next = node.next
           node.next?.prev = node.prev
           node.next = head
           head?.prev = node
           head = node
       }
       if node === tail {
           tail = tail?.prev
           tail?.next = nil
       }
    }

    public func getData() -> [Int] {
        var dataArr: [Int] = []
        if let head {
            var head: Node? = head
            while head != nil {
                dataArr.append(head!.val)
                head = head?.next
            }
        }
        return dataArr
    }
}


class Node {
    var val: Int
    var key: Int
    var next: Node?
    var prev: Node?

    init(_ val: Int, _ key: Int) {
        self.val = val
        self.key = key
    }
}
