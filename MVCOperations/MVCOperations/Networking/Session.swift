//
//  Session.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol Request {
    var urlRequest: URLRequest? { get }
}

protocol Session {
    associatedtype DataType
    func execute(request: Request, handler: (DataType?, Error?) -> ())
}

class NetworkSession: Session {
    
    private let urlSession: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config)
    }
    
    func execute(request: Request, handler: (Data?, Error?) -> ()) {
        guard let urlRequest = request.urlRequest else {
            handler(nil, nil)
            return
        }
        
        
        
    }
    
}
