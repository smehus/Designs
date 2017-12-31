//
//  Downloader.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/31/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol ImageDownloader {
    func downloadImage(with request: Request) -> SignalProducer<UIImage?, NetworkError>
}

class CachedImageDownloader: ImageDownloader {
    
    static let shared = CachedImageDownloader()
    
    var documentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func cachedData(with request: Request) -> Data? {
        guard
            let documents = documentsDirectory,
            let lastPath = request.urlRequest?.url?.lastPathComponent
        else {
            return nil
        }
        
        do {
            return try Data(contentsOf: documents.appendingPathComponent(lastPath))
        } catch {
            return nil
        }
    }
    
    func downloadImage(with request: Request) -> SignalProducer<UIImage?, NetworkError> {
        if let cachedData = cachedData(with: request), let image = UIImage(data: cachedData) {
            return SignalProducer(value: image)
        }
        
        return SessionManager.sharedSession.download(with: request).map { (url) -> UIImage? in
            guard let documents = self.documentsDirectory else {
                return nil
            }
            
            let newLocation = documents.appendingPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.moveItem(at: url, to: newLocation)
                let imageData = try Data(contentsOf: newLocation)
                return UIImage(data: imageData)
                
            } catch let error as NSError {
                print("⁉️ Error cacheing item: \(error)")
                return nil
            }
        }
    }
}
