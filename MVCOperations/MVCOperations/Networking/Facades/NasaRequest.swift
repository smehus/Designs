//
//  NasaRequest.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum NasaRequest {
    case images(query: String)
}

extension NasaRequest: Request {
    
    var method: HTTPMethod {
        return .get
    }
    
    var apiKey: String {
        return "NfQJhPNcBzPoqmZ4Kb8Uqdcnf5sVdIZqQziQYt7k"
    }
    
    var params: [String: String] {
        switch self {
        case .images(let query):
            return ["search" : query]
        }
    }
    
    var baseURL: URL? {
        return URL(string: "https://images-api.nasa.gov")
    }
    
    var taskType: DataTaskType {
        return .dataTask
    }
    
    var urlRequest: URLRequest? {
        guard
            let url = baseURL,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        
        components.queryItems = params.map { (key, value) -> URLQueryItem in
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
        
        return request
    }
}
