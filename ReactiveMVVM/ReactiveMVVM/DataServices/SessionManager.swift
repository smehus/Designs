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
    case unrecognizedHTTPResponse
    case invalideCode
}

internal final class SessionManager {
    
    let session = URLSession.shared
    
    var rules: [Rule] {
        return [statusCodeRule(codeRange: 200...399, shouldContain: true),
                statusCodeRule(codeRange: 400...599, shouldContain: false)]
    }
    
    func execute(request: Request) -> SignalProducer<Result<Data, NoError>, NetworkError> {
        return SignalProducer {[weak self] observer, disposable in
            guard let urlRequest = request.urlRequest else { return }
            self?.session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard
                    let strongSelf = self,
                    let res = response as? HTTPURLResponse,
                    let data = data
                else {
                    observer.send(error: NetworkError.unknown)
                    return
                }
                
                let responseHandler = strongSelf.rules.reduce(into: .success(nil), { (result, rule) in
                    result = rule(res)
                })
                
                switch responseHandler {
                case .failure(let handlerError):
                    observer.send(error: handlerError)
                case .success:
                    observer.send(value: .success(data))
                }
            }.resume()
        }
    }
    
    func statusCodeRule(codeRange: ClosedRange<Int>, shouldContain: Bool) -> Rule {
        return { response in
            return (codeRange.contains(response.statusCode) == shouldContain) ? .success(nil) : .failure(NetworkError.invalideCode)
        }
    }
}

typealias Rule = (HTTPURLResponse) -> Result<()?, NetworkError>
