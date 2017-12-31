//
//  SessionManager.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import Result
import ReactiveSwift

enum NetworkError: Error {
    case error(error: NSError)
    case failedSetup
    case unknown
    case unrecognizedHTTPResponse(code: Int)
    case invalideCode(code: Int)
    
    var localizedDescription: String {
        switch self {
        case .error(let error): return error.localizedDescription
        case .failedSetup: return "Failed Setup"
        case .unknown: return "Unknown Error"
        case .unrecognizedHTTPResponse(let code): return "Unrecognized HTTPURLResponse Status Code \(code)"
        case .invalideCode(let code): return "Invalid Status code: \(code)"
        }
    }
}

internal final class SessionManager {
    
    static var sharedSession = SessionManager()
    
    let session = URLSession.shared
    
    func execute(request: Request) -> SignalProducer<Result<Data, NoError>, NetworkError> {
        return SignalProducer {[unowned self] observer, disposable in
            
            guard let urlRequest = request.urlRequest else {
                observer.send(error: .unknown)
                return
            }
            
            self.session.dataTask(with: urlRequest) { [weak observer] (data, response, error) in
                defer {
                    observer?.sendCompleted()
                }
                
                switch self.validate(response: response, error: error) {
                case .failure(let error):
                    observer?.send(error: error)
                case .success:
                    guard let data = data else {
                        observer?.send(error: NetworkError.unknown)
                        return
                    }
                    
                    observer?.send(value: .success(data))
                }
                
            }.resume()
        }
    }
}


// MARK: - Download Task
extension SessionManager {
    
    func download(with request: Request) -> SignalProducer<URL, NetworkError> {
        
        return SignalProducer { [unowned self] observer, disposable in
            
            guard let urlRequest = request.urlRequest else {
                observer.send(error: NetworkError.failedSetup)
                return
            }
            
            self.session.downloadTask(with: urlRequest) { [weak observer] (localURL, response, error) in
                defer {
                    observer?.sendCompleted()
                }
                
                
                switch self.validate(response: response, error: error) {
                case .failure(let error):
                    observer?.send(error: error)
                case .success:
                    guard let fileURL = localURL else {
                        observer?.send(error: .unknown)
                        return
                    }
                    
                    observer?.send(value: fileURL)
                }
            }
        }
    }
}

extension SessionManager {
    
    var rules: [Rule] {
        return [statusCodeRule(codeRange: 200...399, shouldContain: true),
             statusCodeRule(codeRange: 400...599, shouldContain: false)]
    }
    
    func statusCodeRule(codeRange: ClosedRange<Int>, shouldContain: Bool) -> Rule {
        return { response in
            return (codeRange.contains(response.statusCode) == shouldContain) ? .success(nil) : .failure(NetworkError.invalideCode(code: response.statusCode))
        }
    }
    
    private func validate(response: URLResponse?, error: Error?) -> Result<()?, NetworkError> {
        if let err = error as NSError? {
            return .failure(NetworkError.error(error: err))
        }
        
        guard let res = response as? HTTPURLResponse else {
            return .failure(NetworkError.unknown)
        }
        
        return rules.reduce(.success(nil), { (result, rule) -> Result<()?, NetworkError> in
            switch result {
            case .failure: return result
            case .success: return rule(res)
            }
        })
    }
}

typealias Rule = (HTTPURLResponse) -> Result<()?, NetworkError>
