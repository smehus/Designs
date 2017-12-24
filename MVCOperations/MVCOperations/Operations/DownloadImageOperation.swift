//
//  DownloadImageOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class DownloadImageOperation: Operation {
    
    let url: URL
    var downloadedImage: UIImage?
    
    private var _isFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    private let session = URLSession.shared
    
    init(url: URL) {
        self.url = url
    }
    
    override var isFinished: Bool {
        return _isFinished
    }
    
    override func main() {
        runDownloadTask()
    }
    
    func runDownloadTask() {
        
        // Return cached image
        if let image = CacheManager.shared.image(at: url) {
            print("💚 Using cached image")
            downloadedImage = image
            _isFinished = true
            return
        }
        
        session.downloadTask(with: url) { [weak self] (cacheURL, res, error) in
            
            defer {
                self?._isFinished = true
            }
            
            guard let strongSelf = self else {
                return
            }
            if let err = error {
                print("Image download error \(err)")
            }
            
            if let current = cacheURL {
                do {
                    try CacheManager.shared.cahceFile(at: current, to: strongSelf.url)
                    strongSelf.downloadedImage = CacheManager.shared.image(at: strongSelf.url)
                } catch { }
            }
            
        }.resume()
    }
    
    func runDataTask() {
        session.dataTask(with: url) {  [weak self] (data, response, error) in
            
            guard let data = data else {
                print("MISSING IMAGE DATA")
                self?._isFinished = true
                return
            }
            
            if let err = error {
                print("IMAGE ERROR \(err)")
                self?._isFinished = true
                return
            }
            
            guard let image = UIImage(data: data) else {
                /// FIXME: god damnit - they are youtube videos
                print("ERROR PROCESSING IMAGE \(String(describing: self?.url.absoluteString))")
                self?._isFinished = true
                return
            }
            
            self?.downloadedImage = image
            self?._isFinished = true
            
            }.resume()
    }
}
