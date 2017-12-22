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
    case apod(date: Date)
}

extension NasaRequest: Request {
    
    var method: HTTPMethod {
        return .get
    }
    
    var apiKey: String {
        /// Not really needed
        return "NfQJhPNcBzPoqmZ4Kb8Uqdcnf5sVdIZqQziQYt7k"
    }
    
    var parameters: [String: String] {
        switch self {
        case .images(let query):
            return ["search" : query]
        case .apod(let date):
            let formattedDate = DateFormatter.apodDateFormatter.string(from: date)
            return ["date": formattedDate, "api_key" : apiKey]
        }
    }
    
    var baseURL: URL? {
        switch self {
        case .apod:
            return URL(string: "https://api.nasa.gov/planetary/apod")
        case .images:
            return URL(string: "https://images-api.nasa.gov")
        }
    }
    
    var taskType: DataTaskType {
        return .dataTask
    }
    
    var httpBody: JSON? {
        return [:]
    }
}
