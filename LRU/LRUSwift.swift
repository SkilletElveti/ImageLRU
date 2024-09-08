//
//  LRUSwift.swift
//  ImageLRU
//
//  Created by Shubham Kamdi on 3/3/24.
//

import Foundation
import UIKit

public actor LRUSwift {
    public static let shared = LRUSwift()
    var head: ListNode?
    var tail: ListNode?
    private var store: [Int: ListNode] = [:]
    private var capacity: Int?
    public private(set) var internalCount = 0
}

// MARK: - LRU OPS
extension LRUSwift {
    /// Invoke this method to set the Cache Size
    /// - parameter capacity: The size of the LRU Cache
    ///
    public func set(
        _ capacity: Int
    ) {
        self.capacity = nil
        self.capacity = capacity
    }
    
    /// Invoke this method to get data for a key
    /// - parameter data: The key element of the data you want to fetch
    ///
    public func get(
        _ data: Int
    ) -> Int? {
        if let node = store[data] {
            move(node)
            return node.data
        } else {
            return -1
        }
    }
    
    /// Invoke this method to add data to LRU Cache
    ///  - parameter data: Int representation of data
    ///
    public func put(
        _ data: Int
    ) {
        if let node = store[data] {
            node.data = data
            move(node)
        } else {
            let node = ListNode(data: data)
            node.next = head
            head?.prev = node
            head = node
            store[data] = node
            internalCount += 1
            if tail == nil {
                tail = head
            }
        }
        if internalCount > capacity ?? 0 {
            store.removeValue(forKey: data)
            tail = tail?.prev
            tail?.next = nil
            internalCount -= 1
        }
    }
    
    public func getAllData() -> [Int]? {
        var data: [Int] = []
        if let head {
            var hCopy: ListNode? = head
            while hCopy != nil {
                data.append(hCopy!.data)
                hCopy = hCopy?.next
            }
        }
        return data
    }
}

// MARK: - LRU Tail Ops

fileprivate extension LRUSwift {
    func move(
        _ node: ListNode
    ) {
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
    
    
}

// MARK: - List Node implementation
extension LRUSwift {
    class ListNode {
        var next: ListNode?
        var prev: ListNode?
        var data: Int
       
        init(
            data: Int
        ) {
            self.data = data
        }
    }
}
