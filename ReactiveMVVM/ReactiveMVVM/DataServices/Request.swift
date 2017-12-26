//
//  Request.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

protocol Request {
    var baseURL: URL { get }
    var parameters: [String: String]? { get }
    var httpHeaders: [String: String]? { get }
    var httpBody: Data? { get }
}

extension Request {
    
    var urlRequest: URLRequest? {
        guard var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            print("❌ Failed to create url components")
            return nil
        }
        
        if let params = parameters {
            component.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = component.url else {
            print("❌ Failed to create url")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        if let headers = httpHeaders {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        request.httpBody = httpBody
        
        return request
    }
}

