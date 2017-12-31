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
    case unknown
    case unrecognizedHTTPResponse(code: Int)
    case invalideCode(code: Int)
    
    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown Error"
        case .unrecognizedHTTPResponse(let code): return "Unrecognized HTTPURLResponse Status Code \(code)"
        case .invalideCode(let code): return "Invalid Status code: \(code)"
        }
    }
}

internal final class SessionManager {
    
    static var sharedSession = SessionManager()
    
    let session = URLSession.shared
    
    var rules: [Rule] {
        return [/*statusCodeRule(codeRange: 200...399, shouldContain: true),
                statusCodeRule(codeRange: 400...599, shouldContain: false)*/]
    }
    
    func execute(request: Request) -> SignalProducer<Result<Data, NoError>, NetworkError> {
        return SignalProducer {[weak self] observer, disposable in
            
            guard let strongSelf = self, let urlRequest = request.urlRequest else {
                observer.send(error: .unknown)
                return
            }
            
            strongSelf.session.dataTask(with: urlRequest) { [weak self, weak observer] (data, response, error) in
                defer {
                    observer?.sendCompleted()
                }
                
                guard
                    let strongSelf = self,
                    let strongObserver = observer,
                    let res = response as? HTTPURLResponse,
                    let data = data
                else {
                    observer?.send(error: NetworkError.unknown)
                    return
                }
                
                let responseHandler = strongSelf.rules.reduce(.success(nil), { (result, rule) -> Result<()?, NetworkError> in
                    switch result {
                    case .failure: return result
                    case .success: return rule(res)
                    }
                })
                
                switch responseHandler {
                case .failure(let handlerError):
                    strongObserver.send(error: handlerError)
                case .success:
                    strongObserver.send(value: .success(data))
                }
            }.resume()
        }
    }
    
    func statusCodeRule(codeRange: ClosedRange<Int>, shouldContain: Bool) -> Rule {
        return { response in
            return (codeRange.contains(response.statusCode) == shouldContain) ? .success(nil) : .failure(NetworkError.invalideCode(code: response.statusCode))
        }
    }
}

typealias Rule = (HTTPURLResponse) -> Result<()?, NetworkError>
