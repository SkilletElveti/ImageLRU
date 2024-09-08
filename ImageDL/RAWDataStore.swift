//
//  RAWDataStore.swift
//  ImageLRU
//
//  Created by Shubham Kamdi on 4/2/24.
//

import Foundation
actor RAWDataStore {
    static let shared = RAWDataStore()
    let fileManager = FileManager.default
    var root: URL?
    var docs: URL?
    init() {
        docs = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        if let root = UserDefaults.standard.string(forKey: Constant.root) {
            self.root = URL(string:"file:///\(Constant.path)\(root)/Documents/")
            print("Root Found: \(Constant.path)\(root)/Documents/ \n")
            print("\(self.root?.absoluteURL)\n")
            print("\(docs?.absoluteString)\n")
        } else {
            
            let uuid = docs?.absoluteString.split(separator: "/")
            print("Setting Root: \(uuid![6]) \(uuid)")
            self.root = docs
            UserDefaults.standard.set(uuid![6], forKey: Constant.root)
        }
    }
    
    /// Method used to write data
    /// - parameter rule: ``DataRule`` instance
    /// - parameter data: Raw data instance
    ///
    func writeData(
        rule: DataRule,
        data: Data
    ) {
        let timestamp = Int64(NSDate().timeIntervalSince1970)
        let file = rule.fileName
        let directoryName = rule.directoryName
        if let root {
            var r = root
            print("before writing: \(r) \n")
            r.append(component: "\(timestamp).jpg")
            if fileManager.createFile(atPath: r.absoluteString, contents: nil) { print("file created") } 
            print("writing to: \(r)")
            do {
                try data.write(to: URL(fileURLWithPath: r.path()))
                
//                if fileManager.createFile(atPath: r.absoluteString, contents: data) {
//                    print("wrote file: \(r)")
//                } else {
//                    print("Failed")
//                }
                //print(try fileManager.contentsOfDirectory(atPath: root.absoluteString))
//                if fileManager.createFile(atPath: r.absoluteString, contents: data) {
//                    print("wrote file")
//                } else {
//                    print("file write failed")
//                }
            } catch {
                print("Error in writing: \(error)")
            }
           
        }
    }
    
    func fetchFileNames() {
        if let root {
            var r = root
            do { }
            
        }
    }
}

struct DataRule {
    var fileName: String
    var directoryName: String
}
