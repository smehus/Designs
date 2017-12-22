//
//  Session.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol Session {
    func execute(request: Request, handler: @escaping (JSON?, Error?) -> ())
}

typealias JSON = [String: Any]

class NetworkSession: Session {
    
    private let urlSession: URLSession
    
    init() {
        urlSession = URLSession(configuration: .default)
    }
    
    func execute(request: Request, handler: @escaping (JSON?, Error?) -> ()) {
        guard let urlRequest = request.urlRequest else {
            handler(nil, nil)
            return
        }
        
        switch request.taskType {
        case .dataTask:
            dataTask(with: urlRequest, handler: handler)
        }
    }
    
    private func dataTask(with request: URLRequest, handler: @escaping (JSON?, Error?) -> ()) {
        urlSession.dataTask(with: request) { (data, res, error) in
            if let error = error {
                print("errrror \(error)")
                handler(nil, error)
                return
                
            }
            
            guard let data = data else {
                print("BAD DATA")
                handler(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSON
                handler(json, nil)
            } catch let error {
                handler(nil, error)
            }
        }.resume()
    }
}
