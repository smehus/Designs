//
//  Request.swift
//  MVCOperations
//
//  Created by scott mehus on 12/22/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum DataTaskType {
    case dataTask
}

enum HTTPMethod: String {
    case get = "GET"
}

typealias JSON = [String: Any]

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
                print("Body failed to serialize")
                return request
            }
        }
        
        return request
    }
}
