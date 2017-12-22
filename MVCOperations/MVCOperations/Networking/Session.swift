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
    var baseURL: URL? { get }
    var method: HTTPMethod { get }
    var taskType: DataTaskType { get }
    var urlRequest: URLRequest? { get }
    var httpHeaders: [String: String] { get }
    var httpBody: JSON? { get }
    var parameters:  [String: String] { get }
}

extension Request {
    var httpHeaders: [String: String] {
        return [:]
    }
    
    var urlRequest: URLRequest? {
        guard
            let url = baseURL,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                return nil
        }
        
        components.queryItems = parameters.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let componentURL = components.url else {
            return nil
        }
        
        var request = URLRequest(url: componentURL)
        request.httpMethod = method.rawValue
        for (key, value) in httpHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = httpBody {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = data
            } catch {
                return nil
            }
        }
        
        return request
    }
}

protocol Session {
    func execute(request: Request, handler: @escaping (JSON?, Error?) -> ())
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSON
                handler(json, nil)
            } catch let error {
                handler(nil, error)
            }
        }
        
        task.resume()
    }
}
