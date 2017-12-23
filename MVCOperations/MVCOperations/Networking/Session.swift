//
//  Session.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol Session {
    func dataRequest(request: Request, handler: @escaping (Result<Data>) -> ())
    func fetchAndParse<T>(request: Request, processor: JSONProcessor<T>, handler: @escaping (Result<T>) -> ())
}

enum Result<T> {
    case failed(error: Error)
    case success(data: T)
}

class NetworkSession: Session {
    
    private let urlSession: URLSession
    
    init() {
        urlSession = URLSession(configuration: .default)
    }
    
    func fetchAndParse<T>(request: Request, processor: JSONProcessor<T>, handler: @escaping (Result<T>) -> ()) {
        guard let urlRequest = request.urlRequest else {
            handler(.failed(error: NSError(domain: "Failed", code: 0, userInfo: nil)))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { (data, res, error) in
            if let error = error {
                handler(.failed(error: error))
                return
            } else if let data = data {
                guard let object = processor.process(data: data) else {
                    handler(.failed(error: NSError(domain: "Failed to parse", code: 0, userInfo: nil)))
                    return
                }
                
                handler(.success(data: object))
            }
            
        }.resume()
    }
    
    
    /// Data Request
    func dataRequest(request: Request, handler: @escaping (Result<Data>) -> ()) {
        guard let urlRequest = request.urlRequest else {
            handler(.failed(error: NSError(domain: "Failed", code: 0, userInfo: nil)))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { (data, res, error) in
            if let error = error {
                handler(.failed(error: error))
                return
            } else if let data = data {
                handler(.success(data: data))
            }
        }.resume()
    }
}

class JSONProcessor<T: Codable> {
    
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.apodDateFormatter)
    }
    
    func process(data: Data) -> T? {
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch let error {
            print("🚫 Error decoding apod \(error.localizedDescription)")
            return nil
        }
    }
}
