//
//  Session.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum DataTaskType {
    case dataTask
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol Request {
    var method: HTTPMethod { get }
    var taskType: DataTaskType { get }
    var urlRequest: URLRequest? { get }
}

protocol Session {
    associatedtype DataType
    func execute(request: Request, handler: @escaping (DataType?, Error?) -> ())
}

typealias JSON = [String: Any]

class NetworkSession: Session {
    
    private let urlSession: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config)
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
        let task = urlSession.dataTask(with: request) { (data, res, error) in
            guard let data = data else {
                handler(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                handler(json, nil)
            } catch let error {
                handler(nil, error)
            }
        }
        
        task.resume()
    }
}
