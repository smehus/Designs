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
        session.dataTask(with: url) {  [weak self] (data, response, error) in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                print("ERROR PROCESSING IMAGE")
                self?._isFinished = true
                return
            }

            self?.downloadedImage = image
            self?._isFinished = true
            
        }.resume()
    }
}
