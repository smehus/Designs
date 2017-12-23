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
    case success(result: T?)
    case canceled
}

class ObservedOperation<T>: Operation {
    
    private let operationHandler: (OperationResult<T>) -> ()
    
    required init(handler: @escaping (OperationResult<T>) -> ()) {
        self.operationHandler = handler
    }
    
    override func main() {
        guard !isCancelled else {
            operationHandler(.canceled)
            return
        }
        
        execute()
    }
    
    func execute() {
        fatalError("Subclasses should always override this")
    }

    func finish(data: T?, errors: [Error] = []) {
        print("FINISHED OPERATION ")
        guard !isCancelled else {
            operationHandler(.canceled)
            return
        }
        
        if errors.isEmpty {
            operationHandler(.success(result: data))
        } else {
            operationHandler(.failed(errors: errors))
        }
    }
}

/// Example
class NasaOperation: ObservedOperation<String> {
    
    convenience init(data: String, handler: @escaping (OperationResult<String>) -> ()) {
        self.init(handler: handler)
    }
    
    override func execute() {
        // Do stuff
        finish(data: nil)
    }
}
