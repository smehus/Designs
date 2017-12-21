//
//  SMOperation.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum OperationResult<T> {
    case failed(errors: [Error])
    case success(result: T)
}

class ObservedOperation<T>: Operation {
    
    private let operationObserver: (T) -> ()
    
    init(observer: @escaping (T) -> ()) {
        self.operationObserver = observer
    }
    
    override func main() {
        guard !isCancelled else { return }
        
    }
    
    
    private func finish(errors: [Error] = []) {
        
    }
}
