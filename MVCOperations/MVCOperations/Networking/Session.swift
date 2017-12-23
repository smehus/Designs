//
//  Session.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

protocol Session {
    func execute(request: Request, handler: @escaping (Result<Data>) -> ())
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
    
    func execute(request: Request, handler: @escaping (Result<Data>) -> ()) {
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
    
    private let decoder = JSONDecoder()
    
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
