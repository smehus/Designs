//
//  SessionManager.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import Result

enum NetworkError: Error {
    case unrecognizedHTTPResponse
    case invalideCode
}

internal final class SessionManager {
    
    let session = URLSession.shared
    
    var rules: [Rule] {
        return [statusCodeRule(codeRange: 300...399, shouldContain: true),
                statusCodeRule(codeRange: 400...499, shouldContain: false)]
    }
    
    func execute(request: Request) {
        guard let urlRequest = request.urlRequest else { return }
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let strongSelf = self, let res = response as? HTTPURLResponse else { return }
            
            let responseHandler = strongSelf.rules.reduce(into: .success(nil), { (result, rule) in
                result = rule(res)
            })
            
            switch responseHandler {
            case .failure: break
            case .success: break
            }
        }
        
        task.resume()
    }
    
    func statusCodeRule(codeRange: ClosedRange<Int>, shouldContain: Bool) -> Rule {
        return { response in
            return (codeRange.contains(response.statusCode) == shouldContain) ? .success(nil) : .failure(NetworkError.invalideCode)
        }
    }
}

typealias Rule = (HTTPURLResponse) -> Result<()?, NetworkError>
