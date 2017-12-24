//
//  FileManager.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

enum CacheError: Error {
    case failedToMove
}

internal final class CacheManager {
    
    static let shared = CacheManager()
    
    private var documentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let directory = urls.first else {
            fatalError()
        }
        
        return directory
    }
    
    private func location(from url: URL) -> URL {
        return documentsDirectory.appendingPathComponent(url.lastPathComponent)
    }
    
    func cahceFile(at currentLocation: URL, to toLocation: URL) throws {
        
        guard toLocation.lastPathComponent.count > 0 else {
            throw CacheError.failedToMove
        }
        
        let to = location(from: toLocation)
    
        do {
            try FileManager.default.removeItem(at: to)
        } catch { }
        
        do {
            try FileManager.default.moveItem(at: currentLocation, to: to)
        } catch let error {
            print("❌ Failed to move cache file \(error.localizedDescription)")
            throw CacheError.failedToMove
        }
    }
    
    func file(at url: URL) -> Data? {
        let fileURL = location(from: url)
        return try? Data(contentsOf: fileURL)
    }
    
    func image(at url: URL) -> UIImage? {
        guard let data = file(at: url) else {
            print("‼️ No data for url \(url)")
            return nil
        }
        
        return UIImage(data: data)
    }
}

