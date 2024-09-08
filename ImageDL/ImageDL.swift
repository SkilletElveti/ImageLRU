//
//  ImageDL.swift
//  ImageLRU
//
//  Created by Shubham Kamdi on 4/1/24.
//

import Foundation
import UIKit

public actor ImageDL {
    public static let utility = ImageDL()
    var request: URLRequest?
    
    /// Call this method to initiate download
    /// - parameter image: URL of the image you want to download
    ///
    public func download(
        image: URL
    ) {
        Task {
            try? await createRequest(for: image)
        }
    }
    
    func createRequest(
        for image: URL
    ) async throws {
        
        request = URLRequest(url: image)
        guard let request else { return }
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200,
              let img = UIImage(data: data)
        else { return }
        await RAWDataStore.shared.writeData(rule: .init(fileName: "", directoryName: "Trial"), data: data)
    }
    
    
}
