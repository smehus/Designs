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
        let stringURL = "https://images-api.nasa.gov"
        return URL(string: stringURL)
    }
    
    var taskType: DataTaskType {
        return .dataTask
    }
    
    var urlRequest: URLRequest? {
        guard
            let url = baseURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        
        components.queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        
        return nil
    }
}
