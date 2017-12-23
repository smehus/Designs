//
//  DownloadImageOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class DownloadImageOperation: Operation {
    
    private let completionHandler: (UIImage?, URL?) -> Void
    private let url: URL
    private let session = URLSession(configuration: .default)
    
    init(url: URL, handler: @escaping (UIImage?, URL?) -> Void) {
        self.url = url
        self.completionHandler = handler
    }
    
    override func main() {
        session.dataTask(with: url) {  [weak self] (data, response, error) in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
                else {
                    self?.completionHandler(nil, nil)
                    return
            }
            
            self?.completionHandler(image, self?.url)
            }.resume()
    }
}
